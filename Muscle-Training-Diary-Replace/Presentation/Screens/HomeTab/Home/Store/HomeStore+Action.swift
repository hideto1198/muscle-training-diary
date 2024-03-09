//
//  HomeStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeStore {
    @CasePathable
    enum Action: ViewAction {
        case view(ViewAction)
        case homeDataListAction(HomeDataListStore.Action)
        case homeDataInputListAction(PresentationAction<HomeDataInputListStore.Action>)
        case trainingDataReceived(Result<[Training], Error>)
    }
}

//MARK: - View
extension HomeStore.Action {
    enum ViewAction {
        case buttonTapped
        case saveButtonTapped
        case addDataButtonTapped
    }
}
