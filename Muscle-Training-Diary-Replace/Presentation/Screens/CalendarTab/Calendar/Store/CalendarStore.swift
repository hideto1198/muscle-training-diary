//
//  CalendarStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/12.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarStore {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .forwardButtonTapped:
                    state.calendarModel.forward()
                    return .none
                case .backwordButtonTapped:
                    state.calendarModel.backward()
                    return .none
                }
            case .calendarCellAction(.element(id: let id, action: .view(.onTapped))):
                print(id)
                return .none
            default:
                return .none
            }
        }
        .forEach(\.identifiedArray, action: \.calendarCellAction) {
            CalendarCellStore()
        }
    }
}
