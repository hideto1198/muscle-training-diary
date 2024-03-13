//
//  CalendarCellStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CalendarCellStore {
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapped:
                    return .none
                }
            }
        }
    }
}
