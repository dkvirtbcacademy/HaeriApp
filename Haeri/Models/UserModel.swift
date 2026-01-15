//
//  UserModel.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//


struct UserModel: Identifiable, Codable {
    let id: Int
    let name: String
    let avatar: String
    let email: String
    let password: String
    let savedPosts: [Int]
    let likedPosts: [Int]
}
