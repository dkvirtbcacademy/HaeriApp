//
//  PostBodyView.swift
//  Haeri
//
//  Created by kv on 17.01.26.
//

import SwiftUI

struct PostBodyView: View {
    let post: PostModel
    let isLiked: Bool
    let isSaved: Bool
    let onLike: () -> Void
    let onSave: () -> Void
    
    var body: some View {
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
                onLike()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                    Text("\(post.likes)")
                }
                .foregroundStyle(isLiked ? .red : .darkText)
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
                onSave()
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(.darkText)
                    .font(.system(size: 16))
                    .glassEffect(.circle(size: 40))
            }
        }
        .font(.firago(.xxsmall))
    }
}
