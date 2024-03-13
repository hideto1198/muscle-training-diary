//
//  CalendarTabStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

extension CalendarTabStore {
    @CasePathable
    enum Action: ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case calendarAction(IdentifiedActionOf<CalendarStore>)
        case view(ViewAction)
    }
}

extension CalendarTabStore.Action {
    enum ViewAction {
        case paging
    }
}
