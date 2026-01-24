//
//  PostHeaderView.swift
//  Haeri
//
//  Created by kv on 17.01.26.
//

import SwiftUI

struct PostHeaderView: View {
    let post: PostModel
    let author: UserModel?
    let isPostAuthor: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                Image(author?.avatar ?? "Avatar 1")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .glassEffect(.circle(size: 64))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(author?.name ?? "Anonymous")
                    .font(.firagoBold(.xxsmall))
                    .foregroundStyle(.darkText)
                Text(post.formattedDate)
                    .font(.firago(.xxsmall))
                    .foregroundColor(.secondaryDarkText)
            }
            
            Spacer()
            
            if isPostAuthor {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .font(.system(size: 18))
                        .glassEffect(.circle(size: 44))
                }
            }
        }
    }
}
