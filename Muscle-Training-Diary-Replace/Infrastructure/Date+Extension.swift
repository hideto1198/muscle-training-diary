//
//  Date+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation

extension Date {
    var fullDate: String {
        let formatter = DateFormatter().trainingDate
        return formatter.string(from: self)
    }
}
