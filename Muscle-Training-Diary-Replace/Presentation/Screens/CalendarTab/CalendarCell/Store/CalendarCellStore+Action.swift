//
//  CalendarCellStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

extension CalendarCellStore {
    @CasePathable
    public enum Action: ViewAction {
        case view(ViewAction)
    }
}

extension CalendarCellStore.Action {
    public enum ViewAction {
        case onTapped
    }
}
