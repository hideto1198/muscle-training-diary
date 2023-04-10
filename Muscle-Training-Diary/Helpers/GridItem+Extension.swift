//
//  GridItem+Extension.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/04/04.
//

import Foundation
import SwiftUI

extension GridItem: Equatable {
    var id: String { UUID().uuidString }

    public static func == (lhs: GridItem, rhs: GridItem) -> Bool {
        lhs.id == rhs.id
    }
}
