//
//  AuthManager.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthManager: ObservableObject, AlertHandler {
    
    let userCategories = [
        UserCategoryModel(label: "მშობელი", iconName: "parent", slug: "parent"),
        UserCategoryModel(label: "რესპირატორული დაავადების მქონე", iconName: "respiratory issues", slug: "respiratory"),
        UserCategoryModel(label: "სპორტსმენი / გარე სივრცეში მომუშავე", iconName: "human outside", slug: "sportsman"),
        UserCategoryModel(label: "ხანდაზმული", iconName: "elderly", slug: "elderly"),
        UserCategoryModel(label: "აქტივისტი / მოქალაქე", iconName: "activist", slug: "activist"),
    ]
    
    let avatarOptions = ["Avatar 1", "Avatar 2", "Avatar 3", "Avatar 4", "Avatar 5", "Avatar 6", "Avatar 7", "Avatar 8"]
    
    @Published var currentUser: UserModel?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    @Published var authError: AuthError?
    
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
    deinit {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    private func registerAuthStateHandler() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if let user = user {
                    await self.fetchUserData(userId: user.uid)
                } else {
                    self.currentUser = nil
                    self.isLoggedIn = false
                }
            }
        }
    }
    
    func createUser(name: String, email: String, password: String, avatar: String, categories: [String]) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            let newUser = UserModel(
                id: userId,
                name: name,
                avatar: avatar,
                email: email,
                categories: categories
            )
            
            try await saveUserToFirestore(user: newUser, userId: userId)
            
            await fetchUserData(userId: userId)
            
        } catch let error as AuthError {
            handleAuthError(error)
            self.authError = error
        } catch let error as NSError {
            let authError = mapAuthError(error)
            handleAuthError(authError)
            self.authError = authError
        } catch {
            let authError = AuthError.unknown(error.localizedDescription)
            handleAuthError(authError)
            self.authError = authError
        }
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPassword)
            await fetchUserData(userId: authResult.user.uid)
        } catch let error as NSError {
            let authError = mapAuthError(error)
            handleAuthError(authError)
            self.authError = authError
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isLoggedIn = false
        } catch {
            handleAuthError(.unknown("Failed to log out: \(error.localizedDescription)"))
        }
    }
    
    private func fetchUserData(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            if document.exists {
                let user = try document.data(as: UserModel.self)
                self.currentUser = user
                self.isLoggedIn = true
            } else {
                handleAuthError(.userNotFound)
                self.isLoggedIn = false
            }
        } catch {
            print("Firestore fetch error: \(error)")
            handleAuthError(.firestoreError("Failed to fetch user data: \(error.localizedDescription)"))
            self.isLoggedIn = false
        }
    }
    
    private func saveUserToFirestore(user: UserModel, userId: String) async throws {
        try db.collection("users").document(userId).setData(from: user)
    }
    
    func updateUserName(_ name: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "name": name
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func updateUserAvatar(_ avatar: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "avatar": avatar
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func updateUserCategories(_ categories: [String]) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "categories": categories
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func changePassword(newPassword: String) async {
        guard let user = Auth.auth().currentUser else {
            handleAuthError(.userNotFound)
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await user.updatePassword(to: newPassword)
        } catch let error as NSError {
            handleAuthError(mapAuthError(error))
        }
    }
    
    func addSavedPost(_ postId: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        if user.savedPosts.contains(postId) {
            return
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "savedPosts": FieldValue.arrayUnion([postId])
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func removeSavedPost(_ postId: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "savedPosts": FieldValue.arrayRemove([postId])
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func addLikedPost(_ postId: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        if user.likedPosts.contains(postId) {
            return
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "likedPosts": FieldValue.arrayUnion([postId])
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func removeLikedPost(_ postId: String) async {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return
        }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "likedPosts": FieldValue.arrayRemove([postId])
            ])
            
            await fetchUserData(userId: userId)
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
        }
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else {
            handleAuthError(.userNotFound)
            return
        }
        
        let userId = user.uid
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).delete()
            
            try await user.delete()
            
            currentUser = nil
            isLoggedIn = false
        } catch let error as NSError {
            handleAuthError(mapAuthError(error))
        }
    }
    
    private func mapAuthError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknown(error.localizedDescription)
        }
        
        switch errorCode {
        case .userNotFound:
            return .userNotFound
        case .wrongPassword, .invalidCredential:
            return .invalidCredentials
        case .weakPassword:
            return .weakPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .networkError:
            return .networkError
        case .invalidEmail:
            return .invalidEmail
        case .userDisabled:
            return .userDisabled
        case .tooManyRequests:
            return .tooManyRequests
        case .operationNotAllowed:
            return .operationNotAllowed
        case .requiresRecentLogin:
            return .requiresRecentLogin
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
