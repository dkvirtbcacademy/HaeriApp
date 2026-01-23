//
//  String+Ext.swift
//  Haeri
//
//  Created by kv on 23.01.26.
//

import Foundation

extension String {
    func generateSearchKeywords() -> [String] {
        let lowercased = self.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !lowercased.isEmpty else { return [] }
        
        var keywords: [String] = []
        
        for i in 1...lowercased.count {
            let index = lowercased.index(lowercased.startIndex, offsetBy: i)
            let keyword = String(lowercased[..<index])
            keywords.append(keyword)
        }
        
        let words = lowercased.components(separatedBy: .whitespaces)
        for word in words {
            guard !word.isEmpty else { continue }
            
            for i in 1...word.count {
                let index = word.index(word.startIndex, offsetBy: i)
                let keyword = String(word[..<index])
                if !keywords.contains(keyword) {
                    keywords.append(keyword)
                }
            }
        }
        
        return keywords
    }
}
