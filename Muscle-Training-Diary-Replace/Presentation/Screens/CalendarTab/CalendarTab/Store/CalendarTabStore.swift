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
            case .view(.onCenter):
                let currentState = state.calendarStates.first { $0.id == state.tabSelection }!
                guard state.calendarStates[1] != currentState else { return .none }
                let calendarStates = [
                    CalendarStore.State(year: currentState.backward.0, month: currentState.backward.1),
                    currentState,
                    CalendarStore.State(year: currentState.forward.0, month: currentState.forward.1)
                ]
                state.calendarStates = calendarStates
                return .none
            default:
                return .none
            }
        }
        .forEach(\.identifiedArray, action: \.calendarAction) {
            CalendarStore()
        }
    }
}
