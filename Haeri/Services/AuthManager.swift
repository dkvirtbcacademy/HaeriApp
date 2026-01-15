//
//  AuthManager.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

@MainActor
final class AuthManager: ObservableObject {
    
    let userCategories = [
        UserCategoryModel(label: "მშობელი", iconName: "parent"),
        UserCategoryModel(label: "რესპირატორული დაავადების მქონე", iconName: "respiratory issues"),
        UserCategoryModel(label: "სპორტსმენი / გარე სივრცეში მომუშავე", iconName: "human outside"),
        UserCategoryModel(label: "ხანდაზმული", iconName: "elderly"),
        UserCategoryModel(label: "აქტივისტი / მოქალაქე", iconName: "activist"),
    ]
    
    let avatarOptions = ["Avatar 1", "Avatar 2", "Avatar 3", "Avatar 4", "Avatar 5", "Avatar 6", "Avatar 7", "Avatar 8"]
    
    @Published var currentUser: UserModel = UserModel(
        id: 1,
        name: "test",
        avatar: "Avatar 1",
        email: "test@test.test",
        password: "1234",
        savedPosts: [
            1,
            2
        ],
        likedPosts: [
            1,
            3
        ]
    )
    
    @Published var userId: Int? = 1
    @Published var userName: String? = "Test User"
    @Published var userPassword: String? = "Test1234"
    @Published var userEmail: String? = "test@test.com"
    @Published var userAvatar: String? = "Avatar 1"
    @Published var userCategory: [UserCategoryModel] = [
        UserCategoryModel(label: "მშობელი", iconName: "parent"),
    ]
    @Published var userSavedPosts: [Int] = []
    @Published var userLikedPosts: [Int] = []
    
    @Published var isLoggedIn: Bool = false
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
    }
    
    func changeUserName(_ name: String) {
        userName = name
    }
    
    func changeUserPassword(_ password: String) {
        userPassword = password
    }
    
    func changeUserAvatar(_ avatar: String) {
        userAvatar = avatar
    }
    
    func changeUserCategory(_ category: [UserCategoryModel]) {
        userCategory = category
    }
    
    func addSavedPosts(_ postId: Int) {
        userSavedPosts.append(postId)
    }
    
    func removeSavedPosts(_ postId: Int) {
        userSavedPosts.removeAll { $0 == postId }
    }
    
    func addLikedPosts(_ postId: Int) {
        userLikedPosts.append(postId)
    }
    
    func removeLikedPosts(_ postId: Int) {
        userLikedPosts.removeAll { $0 == postId }
    }
    
    func deleteAccount() {
        logout()
    }
}
