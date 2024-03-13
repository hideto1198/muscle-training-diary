//
//  CalendarStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/12.
//

import Foundation
import ComposableArchitecture

extension CalendarStore {
    @CasePathable
    enum Action: ViewAction {
        case view(ViewAction)
        case calendarCellAction(IdentifiedActionOf<CalendarCellStore>)
    }
}

extension CalendarStore.Action {
    enum ViewAction {
        case forwardButtonTapped
        case backwordButtonTapped
    }
}
