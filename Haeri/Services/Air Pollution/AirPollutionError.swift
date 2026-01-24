//
//  AirPollutionError.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI

enum AirPollutionError: Error {
    case cityNotFound(cityName: String)
    case dataUnavailable
    case coordinatesNotFound(cityName: String)
}

struct AirPollutionAlertContent {
    static func cityNotFound(cityName: String) -> AlertItem {
        AlertItem(
            title: Text("ქალაქი ვერ მოიძებნა"),
            message: Text("'\(cityName)'-ის კოორდინატები ვერ მოიძებნა. გთხოვთ შეამოწმოთ მართლწერა და სცადოთ თავიდან."),
            dismissButton: .default(Text("კარგი"))
        )
    }
    
    static func noCitiesFound(searchTerm: String) -> AlertItem {
        AlertItem(
            title: Text("შედეგები ვერ მოიძებნა"),
            message: Text("'\(searchTerm)'-ს შესაბამისი ქალაქები ვერ მოიძებნა. გთხოვთ სცადოთ სხვა საძიებო სიტყვა."),
            dismissButton: .default(Text("კარგი"))
        )
    }
    
    static let airPollutionDataUnavailable = AlertItem(
        title: Text("მონაცემები მიუწვდომელია"),
        message: Text("ამ ლოკაციისთვის ჰაერის დაბინძურების მონაცემები ამჟამად მიუწვდომელია. გთხოვთ სცადოთ მოგვიანებით."),
        dismissButton: .default(Text("კარგი"))
    )
}
