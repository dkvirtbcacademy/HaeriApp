//
//  AuthError.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI

enum AuthError: Error {
    case userNotFound
    case invalidCredentials
    case weakPassword
    case emailAlreadyInUse
    case networkError
    case firestoreError(String)
    case invalidEmail
    case userDisabled
    case tooManyRequests
    case operationNotAllowed
    case requiresRecentLogin
    case unknown(String)
}

struct AuthAlertContext {
    static let userNotFound = AlertItem(
        title: Text("მომხმარებელი ვერ მოიძებნა"),
        message: Text("ამ ელფოსტის მისამართით ანგარიში არ არსებობს."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let invalidCredentials = AlertItem(
        title: Text("არასწორი მონაცემები"),
        message: Text("თქვენს მიერ შეყვანილი ელფოსტა ან პაროლი არასწორია."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let weakPassword = AlertItem(
        title: Text("სუსტი პაროლი"),
        message: Text("პაროლი უნდა შეიცავდეს მინიმუმ 6 სიმბოლოს."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let emailAlreadyInUse = AlertItem(
        title: Text("ელფოსტა უკვე რეგისტრირებულია"),
        message: Text("ამ ელფოსტით ანგარიში უკვე არსებობს."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let networkError = AlertItem(
        title: Text("ქსელის შეცდომა"),
        message: Text("გთხოვთ შეამოწმოთ ინტერნეტ კავშირი."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static func firestoreError(message: String) -> AlertItem {
        AlertItem(
            title: Text("მონაცემთა ბაზის შეცდომა"),
            message: Text("შეცდომა: \(message)"),
            dismissButton: .default(Text("კარგი"))
        )
    }
    
    static let invalidEmail = AlertItem(
        title: Text("არასწორი ელფოსტა"),
        message: Text("გთხოვთ შეიყვანოთ სწორი ელფოსტის მისამართი."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let userDisabled = AlertItem(
        title: Text("ანგარიში გათიშულია"),
        message: Text("თქვენი ანგარიში გათიშულია."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let tooManyRequests = AlertItem(
        title: Text("ძალიან ბევრი მცდელობა"),
        message: Text("გთხოვთ დაელოდოთ რამდენიმე წუთს და სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let operationNotAllowed = AlertItem(
        title: Text("ოპერაცია დაუშვებელია"),
        message: Text("ავტორიზაციის ეს მეთოდი გამორთულია."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let requiresRecentLogin = AlertItem(
        title: Text("ავთენტიფიკაცია საჭიროა"),
        message: Text("გთხოვთ გახვიდეთ სისტემიდან და შეხვიდეთ ხელახლა."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static func unknown(message: String) -> AlertItem {
        AlertItem(
            title: Text("შეცდომა"),
            message: Text(message),
            dismissButton: .default(Text("კარგი"))
        )
    }
}


struct AuthUIKitAlertContext {
    static let userNotFound = UIKitAlertItem(
        title: "მომხმარებელი ვერ მოიძებნა",
        message: "ამ ელფოსტის მისამართით ანგარიში არ არსებობს."
    )
    
    static let invalidCredentials = UIKitAlertItem(
        title: "არასწორი მონაცემები",
        message: "თქვენს მიერ შეყვანილი ელფოსტა ან პაროლი არასწორია."
    )
    
    static let weakPassword = UIKitAlertItem(
        title: "სუსტი პაროლი",
        message: "პაროლი უნდა შეიცავდეს მინიმუმ 6 სიმბოლოს."
    )
    
    static let emailAlreadyInUse = UIKitAlertItem(
        title: "ელფოსტა უკვე რეგისტრირებულია",
        message: "ამ ელფოსტით ანგარიში უკვე არსებობს."
    )
    
    static let networkError = UIKitAlertItem(
        title: "ქსელის შეცდომა",
        message: "გთხოვთ შეამოწმოთ ინტერნეტ კავშირი."
    )
    
    static func firestoreError(message: String) -> UIKitAlertItem {
        UIKitAlertItem(
            title: "მონაცემთა ბაზის შეცდომა",
            message: "შეცდომა: \(message)"
        )
    }
    
    static let invalidEmail = UIKitAlertItem(
        title: "არასწორი ელფოსტა",
        message: "გთხოვთ შეიყვანოთ სწორი ელფოსტის მისამართი."
    )
    
    static let userDisabled = UIKitAlertItem(
        title: "ანგარიში გათიშულია",
        message: "თქვენი ანგარიში გათიშულია."
    )
    
    static let tooManyRequests = UIKitAlertItem(
        title: "ძალიან ბევრი მცდელობა",
        message: "გთხოვთ დაელოდოთ რამდენიმე წუთს და სცადოთ თავიდან."
    )
    
    static let operationNotAllowed = UIKitAlertItem(
        title: "ოპერაცია დაუშვებელია",
        message: "ავტორიზაციის ეს მეთოდი გამორთულია."
    )
    
    static let requiresRecentLogin = UIKitAlertItem(
        title: "ავთენტიფიკაცია საჭიროა",
        message: "გთხოვთ გახვიდეთ სისტემიდან და შეხვიდეთ ხელახლა."
    )
    
    static func unknown(message: String) -> UIKitAlertItem {
        UIKitAlertItem(
            title: "შეცდომა",
            message: message
        )
    }
}
