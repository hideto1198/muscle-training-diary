//
//  HomeDataListStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation
import ComposableArchitecture

extension HomeDataListStore {
    @ObservableState
    struct State {
        var loadStatus: LoadStatus = .none
        var homeDataList: IdentifiedArrayOf<HomeDataStore.State> = []
        var trainingDataList: [Training] = []
        @Presents var alert: AlertState<Action.Alert>?
    }
}
