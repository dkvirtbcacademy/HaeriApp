//
//  PostCard.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct PostCard: View {
    let post: PostModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(post.author.name)
                    .font(.firago(.xsmall))
                    .foregroundColor(.darkText)
                Spacer()
                Text(post.formattedDate)
                    .font(.firago(.xsmall))
                    .foregroundColor(.darkText)
            }
            
            Text(post.title)
                .font(.firagoMedium(.xmedium))
                .foregroundColor(.darkText)
            
            Text(post.content)
                .font(.firago(.xxsmall))
                .foregroundColor(.darkText)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "bubble.left")
                Text("\(post.comments.count)")
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
            id: 1,
            date: Date(),
            author: UserModel(
                id: 1,
                name: "Dato",
                avatar: "Avatar 1",
                email: "dato@mail.com",
                password: "123456",
                savedPosts: [1],
                likedPosts: [1]
            ),
            title: "Air quality in Rustavi",
            content: "Air feels much cleaner today compared to last week. The AQI readings show significant improvement.",
            likes: 32,
            comments: [
                PostModel.Comment(
                    id: 1,
                    user: UserModel(
                        id: 2,
                        name: "Nino",
                        avatar: "Avatar 2",
                        email: "nino@mail.com",
                        password: "123456",
                        savedPosts: [],
                        likedPosts: [1]
                    ),
                    content: "Yes! I checked AQI and it's much better 🌤️"
                )
            ]
        )
    )
    .padding()
    .background(Color.green)
}
