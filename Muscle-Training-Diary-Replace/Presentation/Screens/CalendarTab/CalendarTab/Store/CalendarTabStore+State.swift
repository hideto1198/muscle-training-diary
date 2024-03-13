//
//  CalendarTabStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

extension CalendarTabStore {
    @ObservableState
    struct State {
        var calendarTabSelection: Int? = 1
        var calendarStates: IdentifiedArrayOf<CalendarStore.State>
        
        init() {
            let today = Date()
            let backMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)
            let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: today)
            let backMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: backMonth!)
            let nextMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: nextMonth!)
            self.calendarStates = [
                .init(year: backMonthComponent.year!, month: backMonthComponent.month!),
                .init(year: todayComponent.year!, month: todayComponent.month!),
                .init(year: nextMonthComponent.year!, month: nextMonthComponent.month!),
            ]
        }
    }
}
