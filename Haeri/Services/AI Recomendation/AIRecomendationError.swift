//
//  AIRecomendationError.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import SwiftUI

enum AIRecomendationError: Error {
    case invalidURL
    case encodingError
    case invalidResponse
    case invalidRequest
    case authenticationError
    case rateLimitError
    case serverError
    case decodingError
    case emptyResponse
}

struct AIRecomendationAlertContext {
    static let invalidURL = AlertItem(
        title: Text("არასწორი URL"),
        message: Text("API-ს URL არასწორია."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let encodingError = AlertItem(
        title: Text("შეცდომა"),
        message: Text("მოთხოვნის შესრულება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let invalidResponse = AlertItem(
        title: Text("არასწორი პასუხი"),
        message: Text("AI სერვისისგან მიღებულია არასწორი პასუხი. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let invalidRequest = AlertItem(
        title: Text("არასწორი მოთხოვნა"),
        message: Text("მოთხოვნის დამუშავება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let authenticationError = AlertItem(
        title: Text("ავთენტიფიკაცია ვერ მოხერხდა"),
        message: Text("AI სერვისთან ავთენტიფიკაცია ვერ მოხერხდა. გთხოვთ დაუკავშირდეთ მხარდაჭერას."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let rateLimitError = AlertItem(
        title: Text("ლიმიტი გადაჭარბებულია"),
        message: Text("ძალიან ბევრი მოთხოვნა. გთხოვთ დაელოდოთ და სცადოთ მოგვიანებით."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let serverError = AlertItem(
        title: Text("სერვერის შეცდომა"),
        message: Text("AI სერვისს პრობლემები აქვს. გთხოვთ სცადოთ მოგვიანებით."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let decodingError = AlertItem(
        title: Text("მონაცემების შეცდომა"),
        message: Text("AI-ს პასუხის დამუშავება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let emptyResponse = AlertItem(
        title: Text("პასუხი არ არის"),
        message: Text("რეკომენდაცია არ გენერირდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
}
