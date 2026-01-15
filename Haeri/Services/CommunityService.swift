//
//  CommunityService.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import Foundation
import Combine

@MainActor
final class CommunityService: ObservableObject {
    
    private let networkManager: NetworkManager
    private let authManager: AuthManager
    
    @Published var posts: [PostModel] = []
    @Published var currentPost: PostModel? = nil
    @Published var selectedFilter: FilterPost? = nil {
        didSet { updateFilteredPosts() }
    }
    
    @Published var searchText: String = ""
    
    @Published var filteredPosts: [PostModel] = []
    
    init(authManager: AuthManager, networkManager: NetworkManager) {
        self.authManager = authManager
        self.networkManager = networkManager
        loadStaticData()
        updateFilteredPosts()   
    }
    
    private func updateFilteredPosts() {
        var result = posts
        
        if let filter = selectedFilter {
            switch filter {
            case .popular:
                result = result.sorted { $0.likes > $1.likes }
            case .myPosts:
                result = result.filter { $0.author.id == authManager.userId }
            case .saved:
                result = result.filter { authManager.userSavedPosts.contains($0.id) }
            case .liked:
                result = result.filter { authManager.userLikedPosts.contains($0.id) }
            case .latest:
                result = result.sorted { $0.date > $1.date }
            }
        }
        
        filteredPosts = result
    }
    
    func addPost(_ post: PostModel) {
        posts.insert(post, at: 0)
        updateFilteredPosts()
    }
    
    func deleteCurrentPost() {
        guard let postId = currentPost?.id else { return }
        
        guard let post = posts.first(where: { $0.id == postId }),
              post.author.id == authManager.userId else {
            return
        }
        
        posts.removeAll { $0.id == postId }
        currentPost = nil
        updateFilteredPosts()
    }
    
    func setCurrentPost(postId: Int) {
        currentPost = posts.first(where: { $0.id == postId })
    }
    
    func addComment(_ comment: PostModel.Comment) {
        guard let postId = currentPost?.id,
              let index = posts.firstIndex(where: { $0.id == postId }) else {
            return
        }
        
        posts[index].comments.append(comment)
        currentPost?.comments.append(comment)
    }
    
    func toggleLike(postId: Int) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else {
            return
        }
        
        if authManager.userLikedPosts.contains(postId) {
            posts[index].likes -= 1
            authManager.removeLikedPosts(postId)
        } else {
            posts[index].likes += 1
            authManager.addLikedPosts(postId)
        }
        
        if currentPost?.id == postId {
            currentPost?.likes = posts[index].likes
        }
        
        updateFilteredPosts()
    }
    
    func savePost(postId: Int) {
        if authManager.userSavedPosts.contains(postId) {
            authManager.userSavedPosts.removeAll { $0 == postId }
        } else {
            authManager.userSavedPosts.append(postId)
        }
        updateFilteredPosts()
    }
    
    private func loadStaticData() {
        let user1 = UserModel(
            id: 1,
            name: "Dato",
            avatar: "Avatar 1",
            email: "dato@mail.com",
            password: "123456",
            savedPosts: [1, 4],
            likedPosts: [1, 2, 5, 7]
        )
        
        let user2 = UserModel(
            id: 2,
            name: "Nino",
            avatar: "Avatar 2",
            email: "nino@mail.com",
            password: "123456",
            savedPosts: [2, 6],
            likedPosts: [1, 3, 6]
        )
        
        let user3 = UserModel(
            id: 3,
            name: "Gio",
            avatar: "Avatar 3",
            email: "gio@mail.com",
            password: "123456",
            savedPosts: [3],
            likedPosts: [1, 2, 3, 4, 8]
        )
        
        let user4 = UserModel(
            id: 4,
            name: "Mariam",
            avatar: "Avatar 4",
            email: "mariam@mail.com",
            password: "123456",
            savedPosts: [5, 7],
            likedPosts: [2, 4, 6]
        )
        
        let user5 = UserModel(
            id: 5,
            name: "Luka",
            avatar: "Avatar 5",
            email: "luka@mail.com",
            password: "123456",
            savedPosts: [8],
            likedPosts: [1, 5, 7, 9]
        )
        
        let now = Date()
        let calendar = Calendar.current
        
        posts = [
            PostModel(
                id: 1,
                date: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
                author: user1,
                title: "Air quality in Rustavi",
                content: "Air feels much cleaner today compared to last week. The AQI dropped from 180 to 65!",
                likes: 32,
                comments: [
                    PostModel.Comment(
                        id: 1,
                        user: user2,
                        content: "Yes! I checked AQI and it's much better 🌤️"
                    ),
                    PostModel.Comment(
                        id: 2,
                        user: user3,
                        content: "Let's hope it stays like this."
                    )
                ]
            ),
            
            PostModel(
                id: 2,
                date: calendar.date(byAdding: .hour, value: -5, to: now) ?? now,
                author: user2,
                title: "When do you check AQI?",
                content: "Do you check air quality before going outside? I use the app every morning.",
                likes: 18,
                comments: [
                    PostModel.Comment(
                        id: 3,
                        user: user1,
                        content: "Every morning before work."
                    ),
                    PostModel.Comment(
                        id: 4,
                        user: user4,
                        content: "I check it before my morning run!"
                    )
                ]
            ),
            
            PostModel(
                id: 3,
                date: calendar.date(byAdding: .hour, value: -8, to: now) ?? now,
                author: user3,
                title: "Mask recommendations",
                content: "Any good masks for polluted days? Looking for something comfortable for daily use.",
                likes: 9,
                comments: []
            ),
            
            PostModel(
                id: 4,
                date: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                author: user4,
                title: "School closures due to pollution",
                content: "Should schools close when AQI goes above 150? My kids have been coughing a lot lately.",
                likes: 45,
                comments: [
                    PostModel.Comment(
                        id: 5,
                        user: user2,
                        content: "Absolutely! Children's health should come first."
                    ),
                    PostModel.Comment(
                        id: 6,
                        user: user5,
                        content: "Some European cities do this at AQI 100+"
                    ),
                    PostModel.Comment(
                        id: 7,
                        user: user1,
                        content: "I keep my kids home when it's really bad."
                    )
                ]
            ),
            
            PostModel(
                id: 5,
                date: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                author: user5,
                title: "Indoor plants that help with air quality",
                content: "Got some snake plants and peace lilies. They actually make a difference indoors! 🌿",
                likes: 27,
                comments: [
                    PostModel.Comment(
                        id: 8,
                        user: user3,
                        content: "I have 10 plants now! My apartment air feels fresher."
                    )
                ]
            ),
            
            PostModel(
                id: 6,
                date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                author: user1,
                title: "Air purifier recommendations?",
                content: "Looking to buy an air purifier. What brands work well in Tbilisi?",
                likes: 15,
                comments: [
                    PostModel.Comment(
                        id: 9,
                        user: user4,
                        content: "I use Xiaomi. Works great and affordable."
                    ),
                    PostModel.Comment(
                        id: 10,
                        user: user2,
                        content: "Philips is expensive but worth it!"
                    )
                ]
            ),
            
            PostModel(
                id: 7,
                date: calendar.date(byAdding: .day, value: -4, to: now) ?? now,
                author: user3,
                title: "Exercise with bad air quality",
                content: "Is it safe to run when AQI is around 100? Or should I stick to indoor workouts?",
                likes: 22,
                comments: [
                    PostModel.Comment(
                        id: 11,
                        user: user5,
                        content: "I avoid outdoor exercise above 75 AQI."
                    )
                ]
            ),
            
            PostModel(
                id: 8,
                date: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                author: user2,
                title: "Government air quality measures",
                content: "What do you think about the new environmental policies? Will they actually help?",
                likes: 38,
                comments: [
                    PostModel.Comment(
                        id: 12,
                        user: user1,
                        content: "We need stricter regulations on factories."
                    ),
                    PostModel.Comment(
                        id: 13,
                        user: user3,
                        content: "Public transport improvements would help too."
                    )
                ]
            ),
            
            PostModel(
                id: 9,
                date: calendar.date(byAdding: .day, value: -7, to: now) ?? now,
                author: user4,
                title: "Seasonal air quality patterns",
                content: "Has anyone noticed air quality is always worse in winter? Why is that?",
                likes: 14,
                comments: [
                    PostModel.Comment(
                        id: 14,
                        user: user5,
                        content: "It's the heating systems and temperature inversions."
                    )
                ]
            ),
            
            PostModel(
                id: 10,
                date: calendar.date(byAdding: .weekOfYear, value: -2, to: now) ?? now,
                author: user5,
                title: "Creating awareness in my neighborhood",
                content: "Started a local group to discuss air quality issues. 20 families joined so far! 💪",
                likes: 56,
                comments: [
                    PostModel.Comment(
                        id: 15,
                        user: user1,
                        content: "This is amazing! How can I start one in my area?"
                    ),
                    PostModel.Comment(
                        id: 16,
                        user: user2,
                        content: "Great initiative! 👏"
                    ),
                    PostModel.Comment(
                        id: 17,
                        user: user4,
                        content: "Would love to join if you're near Saburtalo!"
                    )
                ]
            )
        ]
    }
}
