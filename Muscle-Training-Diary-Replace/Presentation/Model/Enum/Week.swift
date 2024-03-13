//
//  Week.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/09.
//

import Foundation
import SwiftUI

public enum Week: Int, Equatable, CaseIterable {
    /// 未設定
    case none = -1
    /// 日曜日
    case sun = 0
    /// 月曜日
    case mon = 1
    /// 火曜日
    case tue = 2
    /// 水曜日
    case wed = 3
    /// 木曜日
    case thu = 4
    /// 金曜日
    case fri = 5
    /// 土曜日
    case sat = 6
    
    static func convert(value: Int) -> Self {
        switch value {
        case 0: return .sat // 土
        case 1: return .sun // 日
        case 2: return .mon // 月
        case 3: return .tue // 火
        case 4: return .wed // 水
        case 5: return .thu // 木
        case 6: return .fri // 金
        default: return .none
        }
    }
    
    public var foregroundColor: Color {
        switch self {
        case .sat:
            return .blue
        case .sun:
            return .red
        default:
            return .black
        }
    }
    
    public static var weeks: [Self] {
        allCases.filter { $0 != .none }
    }
    
    public var label: String {
        switch self {
        case .none:
            ""
        case .sun:
            "日"
        case .mon:
            "月"
        case .tue:
            "火"
        case .wed:
            "水"
        case .thu:
            "木"
        case .fri:
            "金"
        case .sat:
            "土"
        }
    }
}
