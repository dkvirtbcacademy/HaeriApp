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
    @Published var currentPost: PostModel? = nil
    @Published var currentPostComments: [CommentModel] = []
    @Published var selectedFilter: FilterPost? = nil {
        didSet { updateFilteredPosts() }
    }
    
    @Published var searchText: String = ""
    @Published var filteredPosts: [PostModel] = []
    @Published var isLoading: Bool = false
    
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
                
                self.updateFilteredPosts()
                self.isLoading = false
            }
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
                result = result.sorted { $0.likes > $1.likes }
            case .myPosts:
                result = result.filter { $0.authorId == authManager.currentUser?.id }
            case .saved:
                result = result.filter {
                    guard let postId = $0.id else { return false }
                    return authManager.currentUser?.savedPosts.contains(postId) ?? false
                }
            case .liked:
                result = result.filter {
                    guard let postId = $0.id else { return false }
                    return authManager.currentUser?.likedPosts.contains(postId) ?? false
                }
            case .latest:
                result = result.sorted { $0.date > $1.date }
            }
        }
        
        filteredPosts = result
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
        setupCommentsListener(postId: postId)
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
    
    func toggleLike(postId: String) async {
        let isLiked = authManager.currentUser?.likedPosts.contains(postId) ?? false
        let increment: Int64 = isLiked ? -1 : 1
        
        do {
            try await db.collection("posts").document(postId).updateData([
                "likes": FieldValue.increment(increment)
            ])
            
            if isLiked {
                await authManager.removeLikedPost(postId)
            } else {
                await authManager.addLikedPost(postId)
            }
        } catch {
            print("Error toggling like: \(error)")
        }
    }
    
    func savePost(postId: String) async {
        let isSaved = authManager.currentUser?.savedPosts.contains(postId) ?? false
        
        if isSaved {
            await authManager.removeSavedPost(postId)
        } else {
            await authManager.addSavedPost(postId)
        }
        
        updateFilteredPosts()
    }
}
