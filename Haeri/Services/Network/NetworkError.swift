//
//  NetworkError.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI

enum NetworkError: Error {
    case wrongStatusCode
    case invalidResponse(statusCode: Int, data: Data?)
    case noDataAvailable
    case decodingError
    case noResultsFound
    case networkError
    case invalidURL
}

struct NetworkAlertContext {
    static let wrongStatusCode = AlertItem(
        title: Text("არასწორი სტატუს კოდი"),
        message: Text("სერვერმა დააბრუნა მოულოდნელი სტატუს კოდი. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let noDataAvailable = AlertItem(
        title: Text("მონაცემები არ არის"),
        message: Text("სერვერიდან მონაცემები არ იქნა მიღებული. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let decodingError = AlertItem(
        title: Text("მონაცემების შეცდომა"),
        message: Text("სერვერის პასუხის დამუშავება ვერ მოხერხდა. გთხოვთ სცადოთ თავიდან."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let networkError = AlertItem(
        title: Text("ქსელის შეცდომა"),
        message: Text("სერვერთან დაკავშირება ვერ მოხერხდა. გთხოვთ შეამოწმოთ ინტერნეტ კავშირი."),
        dismissButton: .default(Text("კარგი"))
    )
    
    static let invalidURL = AlertItem(
        title: Text("არასწორი URL"),
        message: Text("სერვერის URL არასწორია. გთხოვთ დაუკავშირდეთ მხარდაჭერას."),
        dismissButton: .default(Text("კარგი"))
    )
}
