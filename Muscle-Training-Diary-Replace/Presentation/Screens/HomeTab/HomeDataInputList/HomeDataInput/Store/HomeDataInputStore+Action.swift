//
//  HomeDataInputStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeDataInputStore {
    @CasePathable
    enum Action: ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
    }
}

// View
extension HomeDataInputStore.Action {
    enum ViewAction {
        case onAppear
        case inputModeChangeButtonTapped
        case trashButtonTapped
        case textEditorTapped(HomeDataInputStore.State.Field)
    }
}
