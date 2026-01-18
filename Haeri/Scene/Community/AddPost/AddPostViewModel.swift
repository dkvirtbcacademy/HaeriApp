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
    }
    
    func createPost() {
        guard let currentUser = authManager.currentUser else {
            return
        }
        
        let newPost = PostModel(
            id: (communityService.posts.map { $0.id }.max() ?? 0) + 1,
            date: Date(),
            author: currentUser,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            likes: 0,
            comments: []
        )
        
        communityService.addPost(newPost)
        coordinator.navigateBack()
    }
    
    func cancel() {
        coordinator.navigateBack()
    }
}
