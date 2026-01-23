//
//  CommunityService.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class CommunityService: ObservableObject {
    
    private let networkManager: NetworkManager
    private let authManager: AuthManager
    private let db = Firestore.firestore()
    
    @Published var posts: [PostModel] = []
    @Published var currentPost: PostModel? = nil {
        didSet { updateCurrentPostState() }
    }
    @Published var currentPostComments: [CommentModel] = []
    @Published var selectedFilter: FilterPost? = nil {
        didSet { applyFilters() }
    }
    @Published var searchText: String = ""
    @Published var filteredPosts: [PostModel] = []
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    
    @Published var isCurrentPostLiked: Bool = false
    @Published var isCurrentPostSaved: Bool = false
    @Published var isCurrentPostAuthor: Bool = false
    
    private var searchablePosts: [PostModel] = []
    private var hasLoadedSearchCache: Bool = false
    
    private var postsListener: ListenerRegistration?
    private var commentsListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager: AuthManager, networkManager: NetworkManager) {
        self.authManager = authManager
        self.networkManager = networkManager
        setupPostsListener()
        setupSearchDebounce()
    }
    
    deinit {
        postsListener?.remove()
        commentsListener?.remove()
        cancellables.removeAll()
    }
    
    // MARK: - Setup
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 2 || $0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func setupPostsListener() {
        isLoading = true
        
        postsListener = db.collection("posts")
            .order(by: "date", descending: true)
            .limit(to: 20)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching posts: \(error)")
                    self.isLoading = false
                    return
                }
                
                self.posts = snapshot?.documents.compactMap { try? $0.data(as: PostModel.self) } ?? []
                
                if let currentPostId = self.currentPost?.id {
                    self.currentPost = self.posts.first(where: { $0.id == currentPostId })
                }
                
                self.applyFilters()
                self.isLoading = false
            }
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
                
                self.currentPostComments = snapshot?.documents.compactMap { try? $0.data(as: CommentModel.self) } ?? []
            }
    }
    
    // MARK: - Search & Filter
    
    private func performSearch(query: String) {
        let trimmedText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            isSearching = false
            applyFilters()
            return
        }
        
        isSearching = true
        let searchQuery = trimmedText.lowercased()
        
        Task { [weak self] in
            if !(self?.hasLoadedSearchCache ?? true) {
                await self?.loadSearchCache()
            }
            
            await self?.executeSearch(query: searchQuery)
        }
    }
    
    private func executeSearch(query: String) async {
        let results = getSearchResults(for: query)
        
        await MainActor.run {
            self.filteredPosts = results
            self.isSearching = false
            self.applyFilters()
        }
    }
    
    private func getSearchResults(for query: String) -> [PostModel] {
        var uniquePosts: [String: PostModel] = [:]
        
        for post in searchablePosts {
            if let id = post.id { uniquePosts[id] = post }
        }
        
        for post in posts {
            if let id = post.id { uniquePosts[id] = post }
        }
        
        return uniquePosts.values
            .filter { post in
                post.title.localizedCaseInsensitiveContains(query) ||
                post.content.localizedCaseInsensitiveContains(query) ||
                post.titleKeywords.contains { $0.localizedCaseInsensitiveContains(query) }
            }
            .sorted { $0.date > $1.date }
    }
    
    private func applyFilters() {
        var result: [PostModel]
        
        if !searchText.isEmpty {
            result = getSearchResults(for: searchText.lowercased())
        } else {
            result = posts
        }
        
        guard let filter = selectedFilter else {
            filteredPosts = result
            return
        }
        
        guard let userId = authManager.currentUser?.id else {
            filteredPosts = result
            return
        }
        
        switch filter {
        case .popular:
            filteredPosts = result.sorted { $0.likes.count > $1.likes.count }
        case .myPosts:
            filteredPosts = result.filter { $0.authorId == userId }
        case .saved:
            filteredPosts = result.filter { $0.saves.contains(userId) }
        case .liked:
            filteredPosts = result.filter { $0.likes.contains(userId) }
        case .latest:
            filteredPosts = result.sorted { $0.date > $1.date }
        }
    }
    
    private func loadSearchCache() async {
        do {
            let snapshot = try await db.collection("posts")
                .order(by: "date", descending: true)
                .limit(to: 200)
                .getDocuments()
            
            let posts = snapshot.documents.compactMap { try? $0.data(as: PostModel.self) }
            
            await MainActor.run {
                self.searchablePosts = posts
                self.hasLoadedSearchCache = true
            }
        } catch {
            print("Error loading search cache: \(error)")
        }
    }
    
    // MARK: - Current Post
    
    func setCurrentPost(postId: String) {
        currentPost = posts.first(where: { $0.id == postId })
        if currentPost != nil {
            setupCommentsListener(postId: postId)
        }
    }
    
    func clearCurrentPost() {
        currentPost = nil
        currentPostComments = []
        commentsListener?.remove()
        isCurrentPostLiked = false
        isCurrentPostSaved = false
        isCurrentPostAuthor = false
    }
    
    private func updateCurrentPostState() {
        guard let post = currentPost, let userId = authManager.currentUser?.id else {
            isCurrentPostLiked = false
            isCurrentPostSaved = false
            isCurrentPostAuthor = false
            return
        }
        
        isCurrentPostLiked = post.likes.contains(userId)
        isCurrentPostSaved = post.saves.contains(userId)
        isCurrentPostAuthor = post.authorId == userId
    }
    
    // MARK: - Post Actions
    
    func toggleLike(postId: String) async {
        guard let userId = authManager.currentUser?.id,
              let post = posts.first(where: { $0.id == postId }) else { return }
        
        let isLiked = post.likes.contains(userId)
        
        do {
            try await db.collection("posts").document(postId).updateData([
                "likes": isLiked ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId])
            ])
        } catch {
            print("Error toggling like: \(error)")
        }
    }
    
    func toggleSave(postId: String) async {
        guard let userId = authManager.currentUser?.id,
              let post = posts.first(where: { $0.id == postId }) else { return }
        
        let isSaved = post.saves.contains(userId)
        
        do {
            try await db.collection("posts").document(postId).updateData([
                "saves": isSaved ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId])
            ])
        } catch {
            print("Error toggling save: \(error)")
        }
    }
    
    func addPost(_ post: PostModel) async {
        do {
            let docRef = db.collection("posts").document()
            var newPost = post
            newPost.id = docRef.documentID
            try docRef.setData(from: newPost)
        } catch {
            print("Error adding post: \(error)")
        }
    }
    
    func deleteCurrentPost() async {
        guard let postId = currentPost?.id,
              currentPost?.authorId == authManager.currentUser?.id else { return }
        
        do {
            let commentsSnapshot = try await db.collection("comments")
                .whereField("postId", isEqualTo: postId)
                .getDocuments()
            
            for document in commentsSnapshot.documents {
                try await document.reference.delete()
            }
            
            try await db.collection("posts").document(postId).delete()
            
            currentPost = nil
            currentPostComments = []
            commentsListener?.remove()
        } catch {
            print("Error deleting post: \(error)")
        }
    }
    
    func addComment(_ comment: CommentModel) async {
        guard let postId = currentPost?.id else { return }
        
        do {
            let docRef = db.collection("comments").document()
            var newComment = comment
            newComment.id = docRef.documentID
            
            currentPostComments.append(newComment)
            
            try docRef.setData(from: newComment)
            
            try await db.collection("posts").document(postId).updateData([
                "commentCount": FieldValue.increment(Int64(1))
            ])
        } catch {
            print("Error adding comment: \(error)")
            currentPostComments.removeAll { $0.id == comment.id }
        }
    }
}
