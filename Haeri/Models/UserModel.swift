//
//  UserModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import FirebaseFirestore

struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let avatar: String
    let email: String
    let categories: [String]
    var savedPosts: [Int]
    var likedPosts: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar
        case email
        case categories
        case savedPosts
        case likedPosts
    }
    
    init(id: String? = nil, name: String, avatar: String, email: String, categories: [String]) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.email = email
        self.categories = categories
        self.savedPosts = []
        self.likedPosts = []
    }
    
    init(id: String?, name: String, avatar: String, email: String, categories: [String], savedPosts: [Int], likedPosts: [Int]) {
        self.id = nil
        self.name = name
        self.avatar = avatar
        self.email = email
        self.categories = categories
        self.savedPosts = savedPosts
        self.likedPosts = likedPosts
    }
}

struct UserCategoryModel: Identifiable {
    let id = UUID()
    let label: String
    let iconName: String
    let slug: String
}
