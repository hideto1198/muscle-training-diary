//
//  CalendarTabStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarTabStore {
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.calendarTabSelection):
                guard let calendarTabSelection = state.calendarTabSelection else { return .none }
                if calendarTabSelection == state.calendarStates.count - 1 {
                    if let lastState = state.calendarStates.last {
                        state.calendarStates.append(CalendarStore.State(year: lastState.forward.0, month: lastState.forward.1))
                    }
                } else if calendarTabSelection == 0 {
                    if let firstState = state.calendarStates.first {
                        state.calendarStates.insert(CalendarStore.State(year: firstState.backward.0, month: firstState.backward.1), at: 0)
                    }
                }
                return .none
            default:
                return .none
            }
        }
        .forEach(\.calendarStates, action: \.calendarAction) {
            CalendarStore()
        }
    }
}
