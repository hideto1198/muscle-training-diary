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
        var calendarStates: IdentifiedArrayOf<CalendarStore.State> = []
    }
}

extension CalendarTabStore.State {
    static func initial() -> Self {
        var calendarTabSelection: Int? = 1
        var calendarStates: IdentifiedArrayOf<CalendarStore.State> = []
        let today = Date()
        let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: today)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)
        let nextMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: nextMonth!)
        for i  in (1 ... 12).reversed() {
            let backMonth = Calendar.current.date(byAdding: .month, value: -i, to: today)
            let backMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: backMonth!)
            calendarStates.append(.init(year: backMonthComponent.year!, month: backMonthComponent.month!))
        }
        calendarStates += [
            .init(year: todayComponent.year!, month: todayComponent.month!),
            .init(year: nextMonthComponent.year!, month: nextMonthComponent.month!),
        ]
        calendarTabSelection = calendarStates.endIndex - 2
        return CalendarTabStore.State(calendarTabSelection: calendarTabSelection, calendarStates: calendarStates)
    }
}
