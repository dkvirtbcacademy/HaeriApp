//
//  CommunityViewmodel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import Combine

@MainActor
final class CommunityViewmodel: ObservableObject {
    
    let coordinator: CommunityCoordinator
    
    init(coordinator: CommunityCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigateToPost(postId: Int) {
        coordinator.navigate(to: .details(postId: postId))
    }
    
    func navigateToAddPost() {
        coordinator.navigate(to: .addPost)
    }
}
