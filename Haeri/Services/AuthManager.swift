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
    
    @Published var userName = "Test User"
    @Published var userPassword = "Test1234"
    @Published var userEmail = "test@test.com"
    @Published var userAvatar = "Avatar 1"
    @Published var userCategory: [UserCategoryModel] = [
        UserCategoryModel(label: "მშობელი", iconName: "parent"),
    ]
    
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
    
    func deleteAccount() {
        logout()
    }
}
