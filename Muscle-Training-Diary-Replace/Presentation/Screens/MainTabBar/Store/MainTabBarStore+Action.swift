//
//  MainTabBarStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension MainTabBarStore {
    @CasePathable
    enum Action: ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        
        // ChildAction
        case homeAction(HomeStore.Action)
        case homeDataInputListAction(PresentationAction<HomeDataInputListStore.Action>)
    }
}

// MARK: - View
extension MainTabBarStore.Action {
    enum ViewAction {
    }
}
