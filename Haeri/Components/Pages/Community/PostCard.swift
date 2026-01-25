//
//  PostCard.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct PostCard: View {
    let post: PostModel
    let author: UserModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(author?.avatar ?? "Avatar 1")
                        .resizable()
                        .frame(maxWidth: 20, maxHeight: 20)
                    Text(author?.name ?? "Anonymous")
                        .font(.firago(.xsmall))
                        .foregroundColor(.secondaryDarkText)
                }
                Spacer()
                Text(post.formattedDate)
                    .font(.firago(.xsmall))
                    .foregroundColor(.secondaryDarkText)
            }
            
            Text(post.title)
                .font(.firagoMedium(.medium))
                .foregroundColor(.darkText.opacity(0.9))
            
            Text(post.content)
                .font(.firago(.xxsmall))
                .foregroundColor(.secondaryDarkText)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "bubble.left")
                Text("\(post.commentCount)")
                    .font(.firago(.xsmall))
                    .foregroundColor(.darkText)
            }
            .foregroundColor(.darkText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .preferredColorScheme(.light)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
#Preview {
    PostCard(
        post: PostModel(
            id: "1",
            date: Date(),
            authorId: "user_1",
            title: "Air quality in Rustavi",
            content: "Air feels much cleaner today compared to last week. The AQI readings show significant improvement.",
            likes: ["userid"],
            saves: ["userid"],
            commentCount: 5
        ),
        author: UserModel(
            id: "1",
            name: "admin",
            avatar: "Avatar 1",
            email: "asasf",
            categories: ["asfasfas"]
        )
    )
    .padding()
    .background(Color.green.opacity(0.3))
}
