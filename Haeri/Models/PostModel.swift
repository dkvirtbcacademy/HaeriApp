//
//  PostModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import FirebaseFirestore

struct PostModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let date: Date
    let authorId: String
    let authorName: String
    let authorAvatar: String
    let title: String
    let content: String
    var likes: [String]
    var saves: [String]
    var commentCount: Int
    var titleKeywords: [String]
    
    init(
        id: String? = nil,
        date: Date = Date(),
        authorId: String,
        authorName: String,
        authorAvatar: String,
        title: String,
        content: String,
        likes: [String] = [],
        saves: [String] = [],
        commentCount: Int = 0
    ) {
        self.id = id
        self.date = date
        self.authorId = authorId
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.title = title
        self.content = content
        self.likes = likes
        self.saves = saves
        self.commentCount = commentCount
        self.titleKeywords = title.generateSearchKeywords()
    }
}

struct CommentModel: Identifiable, Codable {
    @DocumentID var id: String?
    let postId: String
    let userId: String
    let userName: String
    let userAvatar: String
    let content: String
    let date: Date
    
    init(id: String? = nil, postId: String, userId: String, userName: String, userAvatar: String, content: String, date: Date = Date()) {
        self.id = id
        self.postId = postId
        self.userId = userId
        self.userName = userName
        self.userAvatar = userAvatar
        self.content = content
        self.date = date
    }
}

extension PostModel {
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ka_GE")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    var fullFormattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ka_GE")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension CommentModel {
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ka_GE")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
