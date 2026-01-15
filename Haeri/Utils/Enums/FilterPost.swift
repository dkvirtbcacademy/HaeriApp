//
//  FilterPost.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

enum FilterPost: String, CaseIterable, Identifiable {
    case popular = "პოპულარული"
    case myPosts = "ჩემი პოსტები"
    case saved = "შენახული"
    case liked = "მოწონებული"
    case latest = "უახლესი"

    var id: String { rawValue }
}
