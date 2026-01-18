//
//  PostModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation

struct PostModel: Identifiable, Codable {
    let id: Int
    let date: Date
    let author: UserModel
    let title: String
    let content: String
    var likes: Int
    var comments: [Comment]
    
    struct Comment: Codable, Identifiable {
        let id: String
        let user: UserModel
        let content: String
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
