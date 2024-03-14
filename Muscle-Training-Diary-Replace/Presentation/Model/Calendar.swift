//
//  Calendar.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/09.
//

import Foundation
import ComposableArchitecture

public struct CalendarModel: Equatable {
    public let year: Int
    public let month: Int
    
    public var yearMonth: String {
        "\(String(year))年\(String(month))月"
    }
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    func create() -> ([[CalendarCellStore.State]], IdentifiedArrayOf<CalendarCellStore.State>) {
        var dates: [[CalendarCellStore.State]] = []
        var identifiedArray: IdentifiedArrayOf<CalendarCellStore.State> = []
        var space: Int = week(year: self.year, month: self.month, day: 1).rawValue
        let month31: [Int] = [1, 3, 5, 7, 8, 10, 12]
        var maxDate: Int {
            guard !(self.month == 2) else { return self.year.isLeapYear ? 29: 28 }
            return month31.firstIndex(of: self.month) != nil ? 31 : 30
        }
        var date: Int = 1
        
        for _ in 0 ..< 6 {
            var weeks: [CalendarCellStore.State] = []
            for row in 0 ..< 7 {
                if date <= maxDate {
                    if row < space {
                        weeks.append(.init(year: self.year, month: self.month, entity: .init(date: "", week: .none)))
                    } else {
                        let week = week(year: self.year, month: self.month, day: date)
                        weeks.append(.init(year: self.year, month: self.month, entity: .init(date: "\(date)", week: week)))
                        date += 1
                    }
                } else {
                    weeks.append(.init(year: self.year, month: self.month, entity: .init(date: "", week: .none)))
                }
            }
            dates.append(weeks)
            space = 0
        }
        identifiedArray = dates.flatMap({$0}).identifiableArray
        return (dates, identifiedArray)
    }
    
    public func forward() -> (Int, Int) {
        return self.month == 12 ? (self.year + 1, 1) : (self.year, self.month + 1)
    }
    
    public func backward() -> (Int, Int) {
        return self.month == 1 ? (self.year - 1, 12) : (self.year, self.month - 1)
    }
}

extension CalendarModel {
    // MARK: - 曜日計算
    private func week(year: Int, month: Int, day: Int) -> Week {
        let C: Int = Int(floor(Double((month == 1 || month == 2 ? year - 1 : year) / 100)))
        let Y: Int = Int(floor(Double((month == 1 || month == 2 ? year - 1 : year) % 100)))
        let M: Int = Int(floor(Double(((month == 1 ? 13 : month == 2 ? 14 : month) + 1) * 26 / 10)))
        let I: Int = Int(floor(Double(Y / 4)))
        let H: Int = (day + M + Y + I - C * 2 + Int(floor(Double(C / 4))))
        let result: Int = H % 7
        return .convert(value: result)
    }
}
