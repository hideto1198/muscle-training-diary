//
//  Sort.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/29.
//

import SwiftUI
import Foundation

enum Sort: Int, CaseIterable {
    /// あいうえお順
    case alphabet
    /// 回数順
    case count
    /// 更新順
    case rate
    
    var label: String {
        switch self {
        case .alphabet:
            return "名前順"
        case .count:
            return "回数順"
        case .rate:
            return "更新順"
        }
    }
    
    var image: Image {
        switch self {
        case .alphabet:
            return Asset.chiikawa.swiftUIImage
        case .rate:
            return Asset.chiikuwa.swiftUIImage
        case .count:
            return Asset.kurimanju.swiftUIImage
        }
    }
}
