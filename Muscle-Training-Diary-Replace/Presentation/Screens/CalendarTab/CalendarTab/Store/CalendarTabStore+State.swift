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
        var tabSelection: UUID
        var calendarStates: [CalendarStore.State] = []
        var identifiedArray: IdentifiedArrayOf<CalendarStore.State> {
            get { IdentifiedArray(uniqueElements: calendarStates) }
            set { calendarStates = newValue.elements }
        }
    }
}

extension CalendarTabStore.State {
    static func initial() -> Self {
        var calendarStates: [CalendarStore.State] = []
        let today = Date()
        let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: today)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)
        let nextMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: nextMonth!)
        let backMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)
        let backMonthComponent = Calendar.current.dateComponents([.year, .month, .day], from: backMonth!)
        calendarStates = [
            .init(year: backMonthComponent.year!, month: backMonthComponent.month!),
            .init(year: todayComponent.year!, month: todayComponent.month!),
            .init(year: nextMonthComponent.year!, month: nextMonthComponent.month!),
        ]
        let tabSelection: UUID = calendarStates[1].id
        return CalendarTabStore.State(tabSelection: tabSelection, calendarStates: calendarStates)
    }
}
