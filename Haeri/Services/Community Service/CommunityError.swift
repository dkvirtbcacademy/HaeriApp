//
//  CommunityError.swift
//  Haeri
//
//  Created by kv on 23.01.26.
//

import SwiftUI

enum CommunityError: Error {
    case postNotFound
    case unauthorized
    case firestoreError(String)
    case networkError
    case noInternetConnection
    case deletionFailed
    case updateFailed
    case searchFailed
    case commentFailed
    case loadingFailed
    case userFetchFailed
}

struct CommunityAlertContext {
    static let postNotFound = AlertItem(
        title: Text("პოსტი ვერ მოიძებნა"),
        message: Text("მოთხოვნილი პოსტი აღარ არსებობს ან წაშლილია."),
        dismissButton: .default(Text("OK"))
    )
    
    static let unauthorized = AlertItem(
        title: Text("წვდომა აკრძალულია"),
        message: Text("თქვენ არ გაქვთ ამ ოპერაციის შესრულების უფლება."),
        dismissButton: .default(Text("OK"))
    )
    
    static func firestoreError(message: String) -> AlertItem {
        AlertItem(
            title: Text("მონაცემთა ბაზის შეცდომა"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
    
    static let networkError = AlertItem(
        title: Text("ქსელის შეცდომა"),
        message: Text("ინტერნეტთან დაკავშირება ვერ მოხერხდა. გთხოვთ შეამოწმოთ ინტერნეტ კავშირი."),
        dismissButton: .default(Text("OK"))
    )
    
    static let noInternetConnection = AlertItem(
        title: Text("ინტერნეტი არ არის"),
        message: Text("ეს ოპერაცია საჭიროებს ინტერნეტ კავშირს. გთხოვთ შეამოწმოთ თქვენი კავშირი და სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let deletionFailed = AlertItem(
        title: Text("წაშლა ვერ მოხერხდა"),
        message: Text("პოსტის წაშლა ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let updateFailed = AlertItem(
        title: Text("განახლება ვერ მოხერხდა"),
        message: Text("პოსტის განახლება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let searchFailed = AlertItem(
        title: Text("ძიება ვერ მოხერხდა"),
        message: Text("პოსტების ძიება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let commentFailed = AlertItem(
        title: Text("კომენტარის დამატება ვერ მოხერხდა"),
        message: Text("კომენტარის დამატება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let loadingFailed = AlertItem(
        title: Text("ჩატვირთვა ვერ მოხერხდა"),
        message: Text("პოსტების ჩატვირთვა ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("OK"))
    )
    
    static let userFetchFailed = AlertItem(
        title: Text("მომხმარებლის მონაცემები ვერ ჩაიტვირთა"),
        message: Text("ზოგიერთი მომხმარებლის მონაცემების ჩატვირთვა ვერ მოხერხდა. ზოგიერთი სახელი შეიძლება არ გამოჩნდეს."),
        dismissButton: .default(Text("OK"))
    )
}
