//
//  HomeDataStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation
import ComposableArchitecture

extension HomeDataStore {
    enum Action: ViewAction {
        case view(ViewAction)
    }
}

extension HomeDataStore.Action {
    enum ViewAction {
    }
}
