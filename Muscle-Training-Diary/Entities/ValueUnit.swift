//
//  ValueUnit.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/26.
//

enum ValueUnit: Equatable, Hashable, CaseIterable {
    case minutes
    case seconds
    case kilogram

    var label: String {
        switch self {
        case .minutes: return "分"
        case .seconds: return "秒"
        case .kilogram: return "kg"
        }
    }

    static func type(unitString: String) -> Self {
        switch unitString {
        case "分": return minutes
        case "秒": return seconds
        case "kg": return kilogram
        default: fatalError("未定義")
        }
    }
}
