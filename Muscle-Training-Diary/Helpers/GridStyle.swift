//
//  GridStyle.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/04/04.
//

import Foundation
import SwiftUI

enum GridStyle: String, Equatable, CaseIterable, Identifiable, Codable {
    case two = "square.grid.2x2.fill"
    case three = "square.grid.3x3.fill"
    case four = "square.grid.4x3.fill"

    var id: String { rawValue }

    var lable: String {
        switch self {
        case .two: return "2列"
        case .three: return "3列"
        case .four: return "4列"
        }
    }

    var columns: [GridItem] {
        switch self {
        case .two: return [GridItem(), GridItem()]
        case .three: return [GridItem(), GridItem(), GridItem()]
        case .four: return [GridItem(), GridItem(), GridItem(), GridItem()]
        }
    }
}
