//
//  CommunityService.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Combine
import FirebaseFirestore
import Foundation
import Network

@MainActor
final class CommunityService: ObservableObject, AlertHandler {

    private let authManager: AuthManager
    private let db = Firestore.firestore()

    @Published private(set) var allPosts: [PostModel] = []
    @Published var currentPost: PostModel?
    @Published var currentPostComments: [CommentModel] = []
    @Published var selectedFilter: FilterPost?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var alertItem: AlertItem? = nil

    @Published private(set) var userCache: [String: UserModel] = [:]

    var displayedPosts: [PostModel] {
        let filtered = filterPosts(allPosts)
        return sortPosts(filtered)
    }

    var isCurrentPostLiked: Bool {
        guard let post = currentPost, let userId = authManager.currentUser?.id
        else { return false }
        return post.likes.contains(userId)
    }

    var isCurrentPostSaved: Bool {
        guard let post = currentPost, let userId = authManager.currentUser?.id
        else { return false }
        return post.saves.contains(userId)
    }

    var isCurrentPostAuthor: Bool {
        guard let post = currentPost, let userId = authManager.currentUser?.id
        else { return false }
        return post.authorId == userId
    }

    private var lastDocument: DocumentSnapshot?
    private var hasMorePosts: Bool = true
    private let pageSize: Int = 10
    private var isSearchMode: Bool { !searchText.isEmpty }

    private var commentsListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    private var isConnected = true

    init(authManager: AuthManager) {
        self.authManager = authManager
        setupNetworkMonitoring()
        setupSearchDebounce()
        loadInitialPosts()
    }

    deinit {
        commentsListener?.remove()
        cancellables.removeAll()
        networkMonitor.cancel()
    }

    // MARK: - Setup

    private func fetchUsers(userIds: [String]) async {
        let uncachedIds = userIds.filter { userCache[$0] == nil }

        guard !uncachedIds.isEmpty else { return }

        for batch in uncachedIds.chunked(into: 50) {
            do {
                let snapshot = try await db.collection("users")
                    .whereField(FieldPath.documentID(), in: Array(batch))
                    .getDocuments()

                for document in snapshot.documents {
                    if let user = try? document.data(as: UserModel.self) {
                        userCache[document.documentID] = user
                    }
                }
            } catch {
                let missingUsers = uncachedIds.filter { userCache[$0] == nil }
                if !missingUsers.isEmpty {
                    handleCommunityError(.userFetchFailed)
                }
            }
        }
    }

    private func syncCurrentUserToCache() {
        if let currentUser = authManager.currentUser,
            let userId = currentUser.id
        {
            userCache[userId] = currentUser
        }
    }

    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: networkQueue)
    }

    private func checkNetworkConnection() -> Bool {
        guard isConnected else {
            handleCommunityError(.noInternetConnection)
            return false
        }
        return true
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task { await self.performSearch(query: query) }
            }
            .store(in: &cancellables)
    }

    private func loadInitialPosts() {
        isLoading = true

        Task {
            do {
                let snapshot = try await db.collection("posts")
                    .order(by: "date", descending: true)
                    .limit(to: pageSize)
                    .getDocuments()

                allPosts = snapshot.documents.compactMap {
                    try? $0.data(as: PostModel.self)
                }
                lastDocument = snapshot.documents.last
                hasMorePosts = snapshot.documents.count == pageSize

                let authorIds = allPosts.map { $0.authorId }
                await fetchUsers(userIds: authorIds)

                updateCurrentPostIfNeeded()
                isLoading = false
            } catch {
                print("Error loading initial posts: \(error)")
                handleCommunityError(.loadingFailed)
                isLoading = false
            }
        }
    }

    func loadMorePosts() {
        guard !isLoadingMore, !isLoading, hasMorePosts,
            !isSearchMode, let lastDoc = lastDocument
        else { return }

        isLoadingMore = true

        Task {
            do {
                let snapshot = try await db.collection("posts")
                    .order(by: "date", descending: true)
                    .start(afterDocument: lastDoc)
                    .limit(to: pageSize)
                    .getDocuments()

                let newPosts = snapshot.documents.compactMap {
                    try? $0.data(as: PostModel.self)
                }
                allPosts.append(contentsOf: newPosts)
                lastDocument = snapshot.documents.last
                hasMorePosts = snapshot.documents.count == pageSize

                let authorIds = newPosts.map { $0.authorId }
                await fetchUsers(userIds: authorIds)

                isLoadingMore = false
            } catch {
                print("Error loading more posts: \(error)")
                handleCommunityError(.loadingFailed)
                isLoadingMore = false
            }
        }
    }

    // MARK: - Search & Filter

    private func performSearch(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            loadInitialPosts()
            return
        }

        do {
            let searchQuery = trimmed.lowercased()
            let keywords = searchQuery.components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }

            var results: [String: PostModel] = [:]

            for keyword in keywords {
                let snapshot = try await db.collection("posts")
                    .whereField("titleKeywords", arrayContains: keyword)
                    .limit(to: 50)
                    .getDocuments()

                snapshot.documents.compactMap {
                    try? $0.data(as: PostModel.self)
                }
                .forEach { if let id = $0.id { results[id] = $0 } }
            }

            let titleSnapshot = try await db.collection("posts")
                .order(by: "title")
                .start(at: [searchQuery])
                .end(at: [searchQuery + "\u{f8ff}"])
                .limit(to: 50)
                .getDocuments()

            titleSnapshot.documents.compactMap {
                try? $0.data(as: PostModel.self)
            }
            .forEach { if let id = $0.id { results[id] = $0 } }

            allPosts = Array(results.values)
                .filter { post in
                    post.title.localizedCaseInsensitiveContains(searchQuery)
                        || post.content.localizedCaseInsensitiveContains(
                            searchQuery
                        )
                        || post.titleKeywords.contains {
                            $0.localizedCaseInsensitiveContains(searchQuery)
                        }
                }
                .sorted { post1, post2 in
                    let title1Match = post1.title
                        .localizedCaseInsensitiveContains(searchQuery)
                    let title2Match = post2.title
                        .localizedCaseInsensitiveContains(searchQuery)

                    if title1Match != title2Match {
                        return title1Match
                    }
                    return post1.date > post2.date
                }

        } catch {
            print("Error searching posts: \(error)")
            handleCommunityError(.searchFailed)
            allPosts = []
        }
    }

    private func filterPosts(_ posts: [PostModel]) -> [PostModel] {
        guard let filter = selectedFilter,
            let userId = authManager.currentUser?.id
        else {
            return posts
        }

        switch filter {
        case .myPosts:
            return posts.filter { $0.authorId == userId }
        case .saved:
            return posts.filter { $0.saves.contains(userId) }
        case .liked:
            return posts.filter { $0.likes.contains(userId) }
        case .popular, .latest:
            return posts
        }
    }

    private func sortPosts(_ posts: [PostModel]) -> [PostModel] {
        guard let filter = selectedFilter else { return posts }

        switch filter {
        case .popular:
            return posts.sorted { $0.likes.count > $1.likes.count }
        case .latest:
            return posts.sorted { $0.date > $1.date }
        case .myPosts, .saved, .liked:
            return posts
        }
    }

    // MARK: - Current Post

    func setCurrentPost(postId: String) {
        currentPost = allPosts.first(where: { $0.id == postId })

        if currentPost != nil {
            setupCommentsListener(postId: postId)
        }
    }

    func clearCurrentPost() {
        currentPost = nil
        currentPostComments = []
        commentsListener?.remove()
    }

    private func updateCurrentPostIfNeeded() {
        guard let currentPostId = currentPost?.id else { return }
        currentPost = allPosts.first(where: { $0.id == currentPostId })
    }

    private func setupCommentsListener(postId: String) {
        commentsListener?.remove()

        commentsListener = db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .order(by: "date", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching comments: \(error)")
                    return
                }

                let comments =
                    snapshot?.documents.compactMap {
                        try? $0.data(as: CommentModel.self)
                    } ?? []

                self.currentPostComments = comments

                Task { [weak self] in
                    let userIds = comments.map { $0.userId }
                    await self?.fetchUsers(userIds: userIds)
                }
            }
    }

    // MARK: - Post Actions

    func toggleLike(postId: String) async {
        guard checkNetworkConnection() else { return }
        guard let userId = authManager.currentUser?.id else { return }

        await updatePost(postId: postId) { post in
            if post.likes.contains(userId) {
                post.likes.removeAll { $0 == userId }
                return ("likes", FieldValue.arrayRemove([userId]))
            } else {
                post.likes.append(userId)
                return ("likes", FieldValue.arrayUnion([userId]))
            }
        }
    }

    func toggleSave(postId: String) async {
        guard checkNetworkConnection() else { return }
        guard let userId = authManager.currentUser?.id else { return }

        await updatePost(postId: postId) { post in
            if post.saves.contains(userId) {
                post.saves.removeAll { $0 == userId }
                return ("saves", FieldValue.arrayRemove([userId]))
            } else {
                post.saves.append(userId)
                return ("saves", FieldValue.arrayUnion([userId]))
            }
        }
    }

    private func updatePost(
        postId: String,
        update: (inout PostModel) -> (String, Any)
    ) async {
        guard let index = allPosts.firstIndex(where: { $0.id == postId }) else {
            handleCommunityError(.postNotFound)
            return
        }

        let originalPost = allPosts[index]
        let (field, value) = update(&allPosts[index])

        if currentPost?.id == postId {
            currentPost = allPosts[index]
        }

        do {
            try await db.collection("posts").document(postId).updateData([
                field: value
            ])
        } catch {
            print("Error updating post: \(error)")
            handleCommunityError(.updateFailed)

            allPosts[index] = originalPost
            if currentPost?.id == postId {
                currentPost = originalPost
            }
        }
    }

    func addPost(_ post: PostModel) async {
        guard checkNetworkConnection() else { return }
        
        syncCurrentUserToCache()

        do {
            let docRef = db.collection("posts").document()
            var newPost = post
            newPost.id = docRef.documentID
            try docRef.setData(from: newPost)

            allPosts.insert(newPost, at: 0)
        } catch {
            print("Error adding post: \(error)")
            handleCommunityError(.firestoreError(error.localizedDescription))
        }
    }

    func deleteCurrentPost() async {
        guard checkNetworkConnection() else { return }

        guard let postId = currentPost?.id else {
            handleCommunityError(.postNotFound)
            return
        }

        guard currentPost?.authorId == authManager.currentUser?.id else {
            handleCommunityError(.unauthorized)
            return
        }

        do {
            let commentsSnapshot = try await db.collection("comments")
                .whereField("postId", isEqualTo: postId)
                .getDocuments()

            for document in commentsSnapshot.documents {
                try await document.reference.delete()
            }

            try await db.collection("posts").document(postId).delete()

            allPosts.removeAll { $0.id == postId }
            currentPost = nil
            currentPostComments = []
            commentsListener?.remove()
        } catch {
            print("Error deleting post: \(error)")
            handleCommunityError(.deletionFailed)
        }
    }

    func addComment(_ comment: CommentModel) async {
        guard checkNetworkConnection() else { return }
        
        syncCurrentUserToCache()

        guard let postId = currentPost?.id else {
            handleCommunityError(.postNotFound)
            return
        }

        do {
            let docRef = db.collection("comments").document()
            var newComment = comment
            newComment.id = docRef.documentID

            currentPostComments.append(newComment)

            try docRef.setData(from: newComment)

            try await db.collection("posts").document(postId).updateData([
                "commentCount": FieldValue.increment(Int64(1))
            ])

            if let index = allPosts.firstIndex(where: { $0.id == postId }) {
                allPosts[index].commentCount += 1
                if currentPost?.id == postId {
                    currentPost = allPosts[index]
                }
            }
        } catch {
            print("Error adding comment: \(error)")
            handleCommunityError(.commentFailed)
            currentPostComments.removeAll { $0.id == comment.id }
        }
    }
    
    func refreshPosts() async {
        guard checkNetworkConnection() else { return }

        lastDocument = nil
        hasMorePosts = true
        allPosts = []

        await MainActor.run {
            isLoading = true
        }

        do {
            let snapshot = try await db.collection("posts")
                .order(by: "date", descending: true)
                .limit(to: pageSize)
                .getDocuments()

            allPosts = snapshot.documents.compactMap {
                try? $0.data(as: PostModel.self)
            }

            lastDocument = snapshot.documents.last
            hasMorePosts = snapshot.documents.count == pageSize

            let authorIds = allPosts.map { $0.authorId }
            await fetchUsers(userIds: authorIds)

            updateCurrentPostIfNeeded()
        } catch {
            handleCommunityError(.loadingFailed)
        }

        await MainActor.run {
            isLoading = false
        }
    }

}
