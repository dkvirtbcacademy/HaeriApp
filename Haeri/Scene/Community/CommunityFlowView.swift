//
//  CommunityFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct CommunityFlowView: View {
    @ObservedObject var coordinator: CommunityCoordinator
    @ObservedObject var communityService: CommunityService
    @ObservedObject var authManager: AuthManager
    @Environment(\.airQuality) var airQuality
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CommunityPage(
                coordinator: coordinator,
                communityService: communityService
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: CommunityCoordinator.Route.self) { route in
                switch route {
                case .details(let postId):
                    PostDetailsPage(
                        postId: postId,
                        communityService: communityService,
                        authManager: authManager,
                        coordinator: coordinator,
                    )
                    
                case .addPost:
                    AddPostPage(
                        communityService: communityService,
                        authManager: authManager,
                        coordinator: coordinator,
                    )
                }
            }
            .adaptiveBackground()
        }
    }
}

#Preview {
    CommunityFlowView(
        coordinator: CommunityCoordinator(),
        communityService: CommunityService(
            authManager: AuthManager()
        ),
        authManager: AuthManager()
    )
}
