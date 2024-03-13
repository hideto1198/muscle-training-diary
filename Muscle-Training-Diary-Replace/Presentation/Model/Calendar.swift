//
//  Calendar.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/09.
//

import Foundation
import ComposableArchitecture

public struct CalendarModel {
    public var year: Int
    public var month: Int
    public var dates: [[CalendarCellStore.State]] = []
    public var identifiedArray: IdentifiedArrayOf<CalendarCellStore.State> = []
    public var yearMonth: String {
        "\(String(year))年\(String(month))月"
    }
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
        create()
    }
    
    mutating private func create() {
        self.dates.removeAll()
        self.identifiedArray.removeAll()
        var space: Int = week(year: self.year, month: self.month, day: 1).rawValue
        let month31: [Int] = [1, 3, 5, 7, 8, 10, 12]
        var maxDate: Int {
            guard !(self.month == 2) else { return self.year.isLeapYear ? 29: 28 }
            return month31.firstIndex(of: self.month) != nil ? 31 : 30
        }
        var date: Int = 1
        
        for _ in 0...6 {
            var weeks: [CalendarCellStore.State] = []
            for row in 0 ..< 7 {
                if date <= maxDate {
                    if row < space {
                        weeks.append(.init(entity: .init(date: "", week: .none)))
                    } else {
                        let week = week(year: self.year, month: self.month, day: date)
                        weeks.append(.init(entity: .init(date: "\(date)", week: week)))
                        date += 1
                    }
                } else {
                    weeks.append(.init(entity: .init(date: "", week: .none)))
                }
            }
            self.dates.append(weeks)
            space = 0
        }
        self.dates.removeAll(where: { $0.allSatisfy({ $0.entity.date == "" }) })
        self.identifiedArray = self.dates.flatMap({$0}).identifiableArray
    }
    
    public mutating func forward() {
        if self.month == 12 {
            self.month = 1
            self.year += 1
        } else {
            self.month += 1
        }
        create()
    }
    
    public mutating func backward() {
        if self.month == 1 {
            self.month = 12
            self.year -= 1
        } else {
            self.month -= 1
        }
        create()
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
