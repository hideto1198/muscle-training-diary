//
//  Date+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation

extension Date {
    var fullDate: String {
        let formatter = DateFormatter.trainingDate
        return formatter.string(from: self)
    }

    /// 今日か？
    var isToday: Bool {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        return todayComponents.year == dateComponents.year &&
        todayComponents.month == dateComponents.month &&
        todayComponents.day == dateComponents.day
    }
}
