//
//  HomeDataInputList+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeDataInputListStore {
    @ObservableState
    struct State: Equatable {
        var homeDataInputStateList: IdentifiedArrayOf<HomeDataInputStore.State> = [.init(base: .init())]
        var view: ViewState {
            .init(isKeyboardOpen: homeDataInputStateList.contains(where: { $0.focusedField != nil }))
        }
        @Presents var alert: AlertState<Action.Alert>?
    }
}

extension HomeDataInputListStore {
    struct ViewState: Equatable {
        var isKeyboardOpen: Bool
    }
}
