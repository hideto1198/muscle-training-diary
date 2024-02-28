//
//  Count.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

struct Count: Equatable, Hashable {
    var text: String
    var error: Bool {
        guard !text.isEmpty else { return true }
        guard Double(text) != nil else { return true }
        return false
    }
    
    var doubleNumber: Double {
        return Double(text) ?? 0
    }
    
    var intNumber: Int {
        return Int(text) ?? 0
    }
}
