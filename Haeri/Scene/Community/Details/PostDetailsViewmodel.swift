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
    
    private let postId: String
    private let communityService: CommunityService
    private let authManager: AuthManager
    private let coordinator: CommunityCoordinator
    
    var canComment: Bool {
        !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
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
    }
    
    func onAppear() {
        communityService.setCurrentPost(postId: postId)
    }
    
    func toggleLike() {
        Task {
            guard let postId = communityService.currentPost?.id else { return }
            await communityService.toggleLike(postId: postId)
        }
    }
    
    func savePost() {
        Task {
            guard let postId = communityService.currentPost?.id else { return }
            await communityService.toggleSave(postId: postId)
        }
    }
    
    func addComment() {
        guard let user = authManager.currentUser else { return }
        guard let userId = user.id else { return }
        guard canComment else { return }
        
        let comment = CommentModel(
            postId: postId,
            userId: userId,
            content: commentText
        )
        
        Task {
            commentText = ""
            await communityService.addComment(comment)
        }
    }
    
    func deletePost() {
        Task {
            await communityService.deleteCurrentPost()
            coordinator.navigateBack()
        }
    }
    
    func navigateBack() {
        communityService.clearCurrentPost()
        coordinator.navigateBack()
    }
}
