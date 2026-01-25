import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthManager: ObservableObject, AlertHandler {
    
    let userCategories = [
        UserCategoryModel(label: "მშობელი", iconName: "parent", slug: "parent"),
        UserCategoryModel(label: "ორსული", iconName: "pregnant", slug: "pregnant"),
        UserCategoryModel(label: "სპორტსმენი", iconName: "athlete", slug: "sportsman"),
        UserCategoryModel(label: "გარე სივრცეში მომუშავე", iconName: "human outside", slug: "outside"),
        UserCategoryModel(label: "ხანდაზმული", iconName: "elderly", slug: "elderly"),
        UserCategoryModel(label: "აქტივისტი", iconName: "activist", slug: "activist"),
        UserCategoryModel(label: "მოქალაქე", iconName: "citizen", slug: "citizen"),
        UserCategoryModel(label: "რესპირატორული დაავადების მქონე", iconName: "respiratory issues", slug: "respiratory"),
    ]
    
    let avatarOptions = ["Avatar 1", "Avatar 2", "Avatar 3", "Avatar 4", "Avatar 5", "Avatar 6", "Avatar 7", "Avatar 8"]
    
    @Published var currentUser: UserModel?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    @Published var authError: AuthError?
    
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var isInitialLoad = true
    
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
                    if self.isInitialLoad || self.currentUser?.id != user.uid {
                        await self.fetchUserData(userId: user.uid)
                        self.isInitialLoad = false
                    }
                } else {
                    self.currentUser = nil
                    self.isLoggedIn = false
                    self.isInitialLoad = true
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
            
            self.currentUser = newUser
            self.isLoggedIn = true
            
            try await Task.sleep(nanoseconds: 500_000_000)
            await fetchUserData(userId: userId)
            
        } catch let error as AuthError {
            handleAuthError(error)
            self.authError = error
            self.isLoggedIn = false
        } catch let error as NSError {
            let authError = mapAuthError(error)
            handleAuthError(authError)
            self.authError = authError
            self.isLoggedIn = false
        } catch {
            let authError = AuthError.unknown(error.localizedDescription)
            handleAuthError(authError)
            self.authError = authError
            self.isLoggedIn = false
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
            self.isLoggedIn = false
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
            handleAuthError(.firestoreError("Failed to fetch user data: \(error.localizedDescription)"))
            self.isLoggedIn = false
        }
    }
    
    private func saveUserToFirestore(user: UserModel, userId: String) async throws {
        try db.collection("users").document(userId).setData(from: user)
    }
    
    func updateUserName(_ name: String) async -> Bool {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "name": name
            ])
            
            var updatedUser = user
            updatedUser = UserModel(
                id: userId,
                name: name,
                avatar: user.avatar,
                email: user.email,
                categories: user.categories
            )
            self.currentUser = updatedUser
            
            return true
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
            return false
        }
    }
    
    func updateUserAvatar(_ avatar: String) async -> Bool {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "avatar": avatar
            ])
            
            let updatedUser = UserModel(
                id: userId,
                name: user.name,
                avatar: avatar,
                email: user.email,
                categories: user.categories
            )
            self.currentUser = updatedUser
            
            return true
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
            return false
        }
    }
    
    func updateUserCategories(_ categories: [String]) async -> Bool {
        guard let user = currentUser, let userId = user.id else {
            handleAuthError(.userNotFound)
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "categories": categories
            ])
            
            let updatedUser = UserModel(
                id: userId,
                name: user.name,
                avatar: user.avatar,
                email: user.email,
                categories: categories
            )
            self.currentUser = updatedUser
            
            return true
        } catch {
            handleAuthError(.firestoreError(error.localizedDescription))
            return false
        }
    }
    
    func changePassword(newPassword: String) async -> Bool {
        guard let user = Auth.auth().currentUser else {
            handleAuthError(.userNotFound)
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await user.updatePassword(to: newPassword)
            return true
        } catch let error as NSError {
            handleAuthError(mapAuthError(error))
            return false
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
