//
//  HomeGraphStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/29.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeGraphStore {
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .graphTapped(let date, isExclusive: false):
                    guard state.selectedDate != date
                    else {
                        state.selectedDate = nil
                        return .none
                    }
                    state.selectedDate = date
                    return .none
                case .graphTapped(let date, isExclusive: true):
                    state.selectedDate = date
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
