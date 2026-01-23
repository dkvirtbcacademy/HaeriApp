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
    
    init(
        id: String? = nil,
        name: String,
        avatar: String,
        email: String,
        categories: [String],
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.email = email
        self.categories = categories
    }
}

struct UserCategoryModel: Identifiable {
    let id = UUID()
    let label: String
    let iconName: String
    let slug: String
}
