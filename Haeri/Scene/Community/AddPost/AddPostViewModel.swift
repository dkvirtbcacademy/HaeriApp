//
//  AddPostViewModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Combine
import Foundation

@MainActor
final class AddPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var isSubmitting: Bool = false
    
    private let communityService: CommunityService
    private let authManager: AuthManager
    private let coordinator: CommunityCoordinator
    
    init(
        communityService: CommunityService,
        authManager: AuthManager,
        coordinator: CommunityCoordinator
    ) {
        self.communityService = communityService
        self.authManager = authManager
        self.coordinator = coordinator
    }
    
    var canPost: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isSubmitting
    }
    
    func createPost() {
        guard let currentUser = authManager.currentUser,
              let userId = currentUser.id else {
            return
        }
        
        Task {
            isSubmitting = true
            
            let newPost = PostModel(
                id: nil,
                date: Date(),
                authorId: userId,
                authorName: currentUser.name,
                authorAvatar: currentUser.avatar,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                likes: [],
                saves: [],
                commentCount: 0
            )
            
            await communityService.addPost(newPost)
            
            isSubmitting = false
            coordinator.navigateBack()
        }
    }
    
    func cancel() {
        coordinator.navigateBack()
    }
}
