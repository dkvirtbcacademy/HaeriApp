//
//  CommentsSection.swift
//  Haeri
//
//  Created by kv on 17.01.26.
//

import SwiftUI

struct CommentsSection: View {
    let comments: [CommentModel]
    let userCache: [String: UserModel]
    @Binding var commentText: String
    let canComment: Bool
    let onAddComment: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("კომენტარები:")
                .font(.firagoMedium(.medium))
                .foregroundStyle(.darkText.opacity(0.9))
            
            ForEach(comments) { comment in
                let user = userCache[comment.userId]
                
                HStack(alignment: .top, spacing: 12) {
                    Image(user?.avatar ?? "Avatar 1")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .glassEffect(.circle(size: 50))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.name ?? "Anonymous")
                            .font(.firagoMedium(.medium))
                            .foregroundStyle(.darkText)
                        
                        Text(comment.content)
                            .font(.firago(.xxsmall))
                            .foregroundStyle(.darkText.opacity(0.9))
                    }
                }
            }
            
            HStack(spacing: 20) {
                TextField("დაწერე კომენტარი...", text: $commentText)
                    .customTextFieldStyle()
                    .animation(.none, value: commentText)
                
                Button {
                    onAddComment()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .glassEffect(.circle(size: 40))
                }
                .disabled(!canComment)
            }
        }
        .padding(.bottom, 40)
    }
}
