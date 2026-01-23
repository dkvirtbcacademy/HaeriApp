//
//  PostDetailsPage.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct PostDetailsPage: View {
    @StateObject private var viewModel: PostDetailsViewModel
    @ObservedObject var communityService: CommunityService
    @Environment(\.airQuality) var airQuality
    
    init(
        postId: String,
        communityService: CommunityService,
        authManager: AuthManager,
        coordinator: CommunityCoordinator
    ) {
        self.communityService = communityService
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
                    
                    if let post = communityService.currentPost {
                        PostHeaderView(
                            post: post,
                            isPostAuthor: communityService.isCurrentPostAuthor,
                            onDelete: { viewModel.deletePost() }
                        )
                        
                        PostBodyView(
                            post: post,
                            isLiked: communityService.isCurrentPostLiked,
                            isSaved: communityService.isCurrentPostSaved,
                            onLike: { viewModel.toggleLike() },
                            onSave: { viewModel.savePost() }
                        )
                        
                        Divider()
                        
                        CommentsSection(
                            comments: communityService.currentPostComments,
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
        .alert(item: $communityService.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailsPage(
            postId: "1",
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
