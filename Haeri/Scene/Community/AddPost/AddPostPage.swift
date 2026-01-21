//
//  AddPostPage.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI
import Combine

struct AddPostPage: View {
    @StateObject private var viewModel: AddPostViewModel
    @Environment(\.airQuality) var airQuality
    
    init(
        communityService: CommunityService,
        authManager: AuthManager,
        coordinator: CommunityCoordinator
    ) {
        _viewModel = StateObject(wrappedValue: AddPostViewModel(
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("სათაური")
                            .font(.firagoMedium(.medium))
                            .foregroundStyle(.darkText)
                        
                        TextField("შეიყვანეთ სათაური", text: $viewModel.title)
                            .customTextFieldStyle()
                            .characterLimit($viewModel.title, limit: 80)
                            .animation(.none, value: viewModel.title)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("შინაარსი")
                            .font(.firagoMedium(.medium))
                            .foregroundStyle(.darkText)
                        
                        TextEditor(text: $viewModel.content)
                            .font(.firago(.xsmall))
                            .foregroundColor(.text)
                            .frame(height: 200)
                            .padding(12)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.text, lineWidth: 1)
                            )
                            .scrollContentBackground(.hidden)
                    }
                    
                    SwiftUIButton(label: "გამოქვეყნება", isDisabled: !viewModel.canPost) {
                        viewModel.createPost()
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .dismissKeyboardOnDrag()
            .dismissKeyboardOnTap()
            
            SwiftUIPageHeader(pageName: "ახალი პოსტი") {
                viewModel.cancel()
            }
        }
        .navigationBarHidden(true)
        .adaptiveBackground()
    }
}

#Preview {
    NavigationStack {
        AddPostPage(
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
