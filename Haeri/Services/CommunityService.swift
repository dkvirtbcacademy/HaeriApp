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
        didSet { updateFilteredPosts() }
    }
    
    @Published var searchText: String = ""
    @Published var filteredPosts: [PostModel] = []
    @Published var isLoading: Bool = false
    
    @Published var isCurrentPostLiked: Bool = false
    @Published var isCurrentPostSaved: Bool = false
    @Published var isCurrentPostAuthor: Bool = false
    
    private var postsListener: ListenerRegistration?
    private var commentsListener: ListenerRegistration?
    
    init(authManager: AuthManager, networkManager: NetworkManager) {
        self.authManager = authManager
        self.networkManager = networkManager
        setupPostsListener()
    }
    
    deinit {
        postsListener?.remove()
        commentsListener?.remove()
    }
    
    private func setupPostsListener() {
        isLoading = true
        
        postsListener = db.collection("posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching posts: \(error)")
                    self.isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.isLoading = false
                    return
                }
                
                self.posts = documents.compactMap { doc -> PostModel? in
                    try? doc.data(as: PostModel.self)
                }
                
                if let currentPostId = self.currentPost?.id {
                    self.currentPost = self.posts.first(where: { $0.id == currentPostId })
                }
                
                self.updateFilteredPosts()
                self.isLoading = false
            }
    }
    
    private func updateCurrentPostState() {
        guard let post = currentPost,
              let userId = authManager.currentUser?.id else {
            isCurrentPostLiked = false
            isCurrentPostSaved = false
            isCurrentPostAuthor = false
            return
        }
        
        isCurrentPostLiked = post.likes.contains(userId)
        isCurrentPostSaved = post.saves.contains(userId)
        isCurrentPostAuthor = post.authorId == userId
    }
    
    private func setupCommentsListener(postId: String) {
        commentsListener?.remove()
        
        commentsListener = db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .order(by: "date", descending: false)
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching comments: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No snapshot in comments listener")
                    return
                }
                
                self.currentPostComments = snapshot.documents.compactMap { doc -> CommentModel? in
                    do {
                        let comment = try doc.data(as: CommentModel.self)
                        return comment
                    } catch {
                        print("Failed to decode comment: \(error)")
                        return nil
                    }
                }
            }
    }
    
    private func updateFilteredPosts() {
        var result = posts
        
        if let filter = selectedFilter {
            switch filter {
            case .popular:
                result = result.sorted { $0.likes.count > $1.likes.count }
            case .myPosts:
                result = result.filter { $0.authorId == authManager.currentUser?.id }
            case .saved:
                result = result.filter {
                    guard let userId = authManager.currentUser?.id else { return false }
                    return $0.saves.contains(userId)
                }
            case .liked:
                result = result.filter {
                    guard let userId = authManager.currentUser?.id else { return false }
                    return $0.likes.contains(userId)
                }
            case .latest:
                result = result.sorted { $0.date > $1.date }
            }
        }
        
        filteredPosts = result
    }
    
    
    func toggleLike(postId: String) async {
        guard let userId = authManager.currentUser?.id else { return }
        
        guard let post = posts.first(where: { $0.id == postId }) else { return }
        let isLiked = post.likes.contains(userId)
        
        do {
            if isLiked {
                try await db.collection("posts").document(postId).updateData([
                    "likes": FieldValue.arrayRemove([userId])
                ])
            } else {
                try await db.collection("posts").document(postId).updateData([
                    "likes": FieldValue.arrayUnion([userId])
                ])
            }
        } catch {
            print("Error toggling like: \(error)")
        }
    }
    
    func toggleSave(postId: String) async {
        guard let userId = authManager.currentUser?.id else { return }
        
        guard let post = posts.first(where: { $0.id == postId }) else { return }
        let isSaved = post.saves.contains(userId)
        
        do {
            if isSaved {
                try await db.collection("posts").document(postId).updateData([
                    "saves": FieldValue.arrayRemove([userId])
                ])
            } else {
                try await db.collection("posts").document(postId).updateData([
                    "saves": FieldValue.arrayUnion([userId])
                ])
            }
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
        guard let postId = currentPost?.id else { return }
        guard currentPost?.authorId == authManager.currentUser?.id else { return }
        
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
    
    func setCurrentPost(postId: String) {
        print("Setting current post: \(postId)")
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
    
    func addComment(_ comment: CommentModel) async {
        guard let postId = currentPost?.id else {
            return
        }
        
        do {
            let docRef = db.collection("comments").document()
            var newComment = comment
            newComment.id = docRef.documentID
            
            self.currentPostComments.append(newComment)
            
            try docRef.setData(from: newComment)
            
            try await db.collection("posts").document(postId).updateData([
                "commentCount": FieldValue.increment(Int64(1))
            ])
        } catch {
            print("Error adding comment: \(error)")
            self.currentPostComments.removeAll { $0.id == comment.id }
        }
    }
}
