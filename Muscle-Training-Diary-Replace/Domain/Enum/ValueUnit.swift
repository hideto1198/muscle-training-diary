//
//  ValueUnit.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

enum ValueUnit: Int, Equatable, CaseIterable, Codable {
    case minutes = 0
    case kilogram = 1
    
    
    var label: String {
        switch self {
        case .minutes:
            return "分"
        case .kilogram:
            return "kg"
        }
    }
}
