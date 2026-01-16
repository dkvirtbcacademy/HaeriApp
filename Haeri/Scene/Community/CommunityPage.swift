//
//  CommunityPage.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct CommunityPage: View {
    @StateObject private var viewModel: CommunityViewmodel
    @ObservedObject var communityService: CommunityService
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showButton: Bool = true
    
    init(
        coordinator: CommunityCoordinator,
        communityService: CommunityService
    ) {
        self.communityService = communityService
        _viewModel = StateObject(
            wrappedValue: CommunityViewmodel(coordinator: coordinator)
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(communityService.filteredPosts) { post in
                        PostCard(post: post)
                            .onTapGesture {
                                viewModel.navigateToPost(postId: post.id)
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.top, headerHeight)
                .padding(.bottom, 100)
                .background(
                    GeometryReader { geometry -> Color in
                        let offset = geometry.frame(in: .named("scrollView"))
                            .minY
                        
                        DispatchQueue.main.async {
                            let diff = offset - scrollOffset
                            
                            if diff < -5 && showButton && offset < -50 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showButton = false
                                }
                            } else if (diff > 5 || offset > -30) && !showButton
                            {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showButton = true
                                }
                            }
                            
                            scrollOffset = offset
                        }
                        
                        return Color.clear
                    }
                )
            }
            .coordinateSpace(name: "scrollView")
            
            VStack(spacing: 10) {
                SearchBar()
                FilterView(selectedFilter: $communityService.selectedFilter)
            }
            .padding(.bottom, 20)
            .background(.ultraThinMaterial)
            .preferredColorScheme(.light)
            
            VStack {
                Spacer()
                AddCityButton(
                    isVisible: showButton,
                    label: "დაამატე პოსტი"
                ) {
                    viewModel.navigateToAddPost()
                }
                .padding(.bottom, 10)
            }
        }
    }
    
    private var headerHeight: CGFloat {
        140
    }
}

#Preview {
    CommunityPage(
        coordinator: CommunityCoordinator(),
        communityService: CommunityService(
            authManager: AuthManager(),
            networkManager: NetworkManager()
        )
    )
    .preferredColorScheme(.dark)
}
