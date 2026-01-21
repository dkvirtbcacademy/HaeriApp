//
//  CommunityCoordinator.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import Combine

@MainActor
final class CommunityCoordinator: ObservableObject {
    
    enum Route: Hashable {
        case details(postId: String)
        case addPost
    }
    
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
