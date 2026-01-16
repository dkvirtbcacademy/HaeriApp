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
                        postHeader(post: post)
                        postBody(post: post)
                        
                        Divider()
                        
                        commentsSection(post: post)
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
    
    @ViewBuilder
    private func postHeader(post: PostModel) -> some View {
        HStack {
            ZStack {
                Image(post.author.avatar)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .glassEffect(.circle(size: 64))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.author.name)
                    .font(.firagoBold(.xxsmall))
                    .foregroundStyle(.darkText)
                Text(post.formattedDate)
                    .font(.firago(.xxsmall))
                    .foregroundColor(.secondaryDarkText)
            }
            
            Spacer()
            
            if viewModel.isPostAuthor() {
                Button(role: .destructive) {
                    viewModel.deletePost()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .font(.system(size: 18))
                        .glassEffect(.circle(size: 44))
                }
            }
        }
    }
    
    @ViewBuilder
    private func postBody(post: PostModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(post.title)
                .font(.firagoBold(.xmedium))
                .foregroundStyle(.darkText)
            
            Text(post.content)
                .font(.firago(.medium))
                .foregroundStyle(.darkText.opacity(0.9))
        }
        
        HStack(spacing: 20) {
            Button {
                viewModel.toggleLike()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    Text("\(post.likes)")
                }
                .foregroundStyle(viewModel.isLiked ? .red : .darkText)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .glassEffect(.capsule)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "message")
                Text("\(post.comments.count)")
            }
            .foregroundStyle(.darkText).opacity(0.7)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .glassEffect(.capsule)
            
            Spacer()
            
            Button {
                viewModel.savePost()
            } label: {
                Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(.darkText)
                    .font(.system(size: 16))
                    .glassEffect(.circle(size: 40))
            }
        }
        .font(.firago(.xxsmall))
    }
    
    @ViewBuilder
    private func commentsSection(post: PostModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("კომენტარები:")
                .font(.firagoMedium(.medium))
                .foregroundStyle(.darkText.opacity(0.9))
            
            ForEach(post.comments) { comment in
                HStack(alignment: .top, spacing: 12) {
                    Image(comment.user.avatar)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .glassEffect(.circle(size: 50))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.user.name)
                            .font(.firagoMedium(.medium))
                            .foregroundStyle(.darkText)
                        
                        Text(comment.content)
                            .font(.firago(.xxsmall))
                            .foregroundStyle(.darkText.opacity(0.9))
                    }
                }
            }
            
            HStack(spacing: 20) {
                TextField("დაწერე კომენტარი...", text: $viewModel.commentText)
                    .customTextFieldStyle()
                    .animation(.none, value: viewModel.commentText)
                
                Button {
                    viewModel.addComment()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .glassEffect(.circle(size: 40))
                }
                .disabled(!viewModel.canComment)
            }
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
