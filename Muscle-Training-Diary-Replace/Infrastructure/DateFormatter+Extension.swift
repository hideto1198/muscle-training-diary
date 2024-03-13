//
//  DateFormatter+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation

extension DateFormatter {
    static var trainingDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }
    
    static var fullDate: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日 hh:mm:ss"
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            return formatter
        }
}
