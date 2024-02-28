//
//  HomeDataInputList+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeDataInputListStore {
    @CasePathable
    enum Action: ViewAction {
        case view(ViewAction)
        case homeDataInputActions(IdentifiedActionOf<HomeDataInputStore>)
        case saveDone
        
        case alert(PresentationAction<Alert>)
        enum Alert {
            case okButtonTapped
        }
    }
}

extension HomeDataInputListStore.Action {
    enum ViewAction {
        case addInputData
        case keyboardClose
        case leftSwiped
        case rightSwiped
        case saveButtonTapped
        case dismissModal
    }
}
