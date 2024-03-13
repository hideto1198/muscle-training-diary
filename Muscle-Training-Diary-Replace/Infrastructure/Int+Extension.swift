//
//  Int+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/10.
//

import Foundation

public extension Int {
    /// 閏年か
    var isLeapYear: Bool {
        guard self.isMultiple(of: 4) else { return false }
        guard !self.isMultiple(of: 100), !self.isMultiple(of: 400) else {  return false }
        return true
    }
}
