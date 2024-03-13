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
                if state.previousTabSelection < state.calendarTabSelection {
                    let currentState = state.calendarStates[state.calendarTabSelection]
                    state.calendarStates.append(CalendarStore.State(year: currentState.year, month: currentState.month + 1))
                } else {
                    print("減った")
                }
                state.previousTabSelection = state.calendarTabSelection
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
