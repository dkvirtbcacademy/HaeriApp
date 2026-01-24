//
//  Array+Ext.swift
//  Haeri
//
//  Created by kv on 24.01.26.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
