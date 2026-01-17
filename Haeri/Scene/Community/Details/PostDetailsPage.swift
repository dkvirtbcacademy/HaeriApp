//
//  PostDetailsPage.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct PostDetailsPage: View {
    @StateObject private var viewModel: PostDetailsViewModel
    @Environment(\.airQuality) var airQuality
    
    init(
        postId: Int,
        communityService: CommunityService,
        authManager: AuthManager,
        coordinator: CommunityCoordinator
    ) {
        _viewModel = StateObject(wrappedValue: PostDetailsViewModel(
            postId: postId,
            communityService: communityService,
            authManager: authManager,
            coordinator: coordinator
        ))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Color.clear.frame(height: 60)
                    
                    if let post = viewModel.post {
                        PostHeaderView(
                            post: post,
                            isPostAuthor: viewModel.isPostAuthor(),
                            onDelete: { viewModel.deletePost() }
                        )
                        
                        PostBodyView(
                            post: post,
                            isLiked: viewModel.isLiked,
                            isSaved: viewModel.isSaved,
                            onLike: { viewModel.toggleLike() },
                            onSave: { viewModel.savePost() }
                        )
                        
                        Divider()
                        
                        CommentsSection(
                            comments: post.comments,
                            commentText: $viewModel.commentText,
                            canComment: viewModel.canComment,
                            onAddComment: { viewModel.addComment() }
                        )
                    } else {
                        Text("პოსტი ვერ მოიძებნა")
                            .foregroundStyle(.darkText)
                    }
                }
                .padding(.horizontal)
            }
            .dismissKeyboardOnDrag()
            .dismissKeyboardOnTap()
            
            SwiftUIPageHeader(pageName: "პოსტი") {
                viewModel.navigateBack()
            }
        }
        .navigationBarHidden(true)
        .adaptiveBackground()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailsPage(
            postId: 1,
            communityService: CommunityService(
                authManager: AuthManager(),
                networkManager: NetworkManager()
            ),
            authManager: AuthManager(),
            coordinator: CommunityCoordinator()
        )
    }
    .preferredColorScheme(.light)
}
