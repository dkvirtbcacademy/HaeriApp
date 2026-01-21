//
//  PostDetailsViewModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Combine
import Foundation

@MainActor
final class PostDetailsViewModel: ObservableObject {
    @Published var commentText: String = ""
    @Published var post: PostModel?
    @Published var comments: [CommentModel] = []
    @Published var isLiked: Bool = false
    @Published var isSaved: Bool = false
    
    private let postId: String
    private let communityService: CommunityService
    private let authManager: AuthManager
    private let coordinator: CommunityCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    init(
        postId: String,
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
                guard let self = self else { return nil }
                return posts.first(where: { $0.id == self.postId })
            }
            .assign(to: &$post)
        
        communityService.$currentPost
            .sink { [weak self] currentPost in
                guard let self = self else { return }
                if currentPost?.id == self.postId, self.post == nil {
                    self.post = currentPost
                }
            }
            .store(in: &cancellables)
        
        communityService.$currentPostComments
            .assign(to: &$comments)
        
        authManager.$currentUser
            .map { [weak self] user in
                guard let self = self else { return false }
                return user?.likedPosts.contains(self.postId) ?? false
            }
            .assign(to: &$isLiked)
        
        authManager.$currentUser
            .map { [weak self] user in
                guard let self = self else { return false }
                return user?.savedPosts.contains(self.postId) ?? false
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
        Task {
            await communityService.deleteCurrentPost()
            coordinator.navigateBack()
        }
    }
    
    func toggleLike() {
        Task {
            await communityService.toggleLike(postId: postId)
        }
    }
    
    func savePost() {
        Task {
            await communityService.savePost(postId: postId)
        }
    }
    
    func addComment() {
        guard !commentText.isEmpty,
              let currentUser = authManager.currentUser,
              let userId = currentUser.id
        else {
            return
        }
        let newComment = CommentModel(
            postId: postId,
            userId: userId,
            userName: currentUser.name,
            userAvatar: currentUser.avatar,
            content: commentText,
            date: Date()
        )
        
        Task {
            await communityService.addComment(newComment)
            commentText = ""
        }
    }
    
    var canComment: Bool {
        !commentText.isEmpty && authManager.currentUser != nil
    }
    
    func isPostAuthor() -> Bool {
        guard let post = post,
              let currentUserId = authManager.currentUser?.id else {
            return false
        }
        return post.authorId == currentUserId
    }
}
