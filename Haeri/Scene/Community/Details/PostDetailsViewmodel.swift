//
//  PostDetailsViewModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import Combine

@MainActor
final class PostDetailsViewModel: ObservableObject {
    @Published var commentText: String = ""
    @Published var post: PostModel?
    @Published var isLiked: Bool = false
    @Published var isSaved: Bool = false
    
    private let postId: Int
    private let communityService: CommunityService
    private let authManager: AuthManager
    private let coordinator: CommunityCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    init(
        postId: Int,
        communityService: CommunityService,
        authManager: AuthManager,
        coordinator: CommunityCoordinator
    ) {
        self.postId = postId
        self.communityService = communityService
        self.authManager = authManager
        self.coordinator = coordinator
        
        setupObservers()
    }
    
    private func setupObservers() {
        communityService.$posts
            .map { [weak self] posts in
                posts.first(where: { $0.id == self?.postId })
            }
            .assign(to: &$post)
        
        authManager.$userLikedPosts
            .map { [weak self] likedPosts in
                guard let self = self else { return false }
                return likedPosts.contains(self.postId)
            }
            .assign(to: &$isLiked)
        
        authManager.$userSavedPosts
            .map { [weak self] savedPosts in
                guard let self = self else { return false }
                return savedPosts.contains(self.postId)
            }
            .assign(to: &$isSaved)
    }
    
    func onAppear() {
        communityService.setCurrentPost(postId: postId)
    }
    
    func navigateBack() {
        coordinator.navigateBack()
    }
    
    func deletePost() {
        communityService.deleteCurrentPost()
        coordinator.navigateBack()
    }
    
    func toggleLike() {
        communityService.toggleLike(postId: postId)
    }
    
    func savePost() {
        communityService.savePost(postId: postId)
    }
    
    func addComment() {
        guard !commentText.isEmpty, let post = post else { return }
        
        let newComment = PostModel.Comment(
            id: post.comments.count + 1,
            user: authManager.currentUser,
            content: commentText
        )
        
        communityService.setCurrentPost(postId: postId)
        communityService.addComment(newComment)
        commentText = ""
    }
    
    var canComment: Bool {
        !commentText.isEmpty
    }
    
    func isPostAuthor() -> Bool {
        guard let post = post else { return false }
        return post.author.id == authManager.userId
    }
}
