//
//  HomeDataListStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation
import ComposableArchitecture

extension HomeDataListStore {
    @CasePathable
    enum Action: ViewAction, BindableAction {
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case view(ViewAction)
        case trainingDataReceived(Result<[Training], Error>)
        case homeDataAction(IdentifiedActionOf<HomeDataStore>)
        enum Alert {
            case okButtonTapped(IndexSet)
            case cancelButtonTapped
        }
    }
}

extension HomeDataListStore.Action {
    enum ViewAction {
        case onAppear
        case onDeleteItem(IndexSet)
        case detailLabelTapped
    }
}
