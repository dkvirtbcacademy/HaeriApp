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
                .padding(.top, 140)
                .padding(.bottom, 100)
                .background(scrollOffsetReader)
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
    
    private var scrollOffsetReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scrollView")).minY
                )
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            handleScroll(newOffset: offset)
        }
    }
    
    private func handleScroll(newOffset: CGFloat) {
        let diff = newOffset - scrollOffset
        
        if diff < -5 && showButton && newOffset < -50 {
            withAnimation(.easeInOut(duration: 0.3)) {
                showButton = false
            }
        } else if (diff > 5 || newOffset > -30) && !showButton {
            withAnimation(.easeInOut(duration: 0.3)) {
                showButton = true
            }
        }
        
        scrollOffset = newOffset
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
    .preferredColorScheme(.light)
}
