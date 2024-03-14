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
    enum CancelId { case onPaging }
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.tabSelection):
                return .concatenate(
                    .cancel(id: CancelId.onPaging),
                    .run { send in
                        await send(.view(.onCenter))
                    }.cancellable(id: CancelId.onPaging)
                )
            case .view(.onCenter):
                let currentState = state.calendarStates.first { $0.id == state.tabSelection }!
                guard let currentIndex = state.calendarStates.firstIndex(where: { $0.id == state.tabSelection }),
                      currentIndex != 1
                else { return .none }
                if currentIndex == state.calendarStates.count - 1 {
                    state.calendarStates.append(CalendarStore.State(year: currentState.forward.0, month: currentState.forward.1))
                    state.calendarStates.removeFirst()
                } else if currentIndex == 0 {
                    state.calendarStates.insert(CalendarStore.State(year: currentState.backward.0, month: currentState.backward.1), at: 0)
                    state.calendarStates.removeLast()
                }
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
