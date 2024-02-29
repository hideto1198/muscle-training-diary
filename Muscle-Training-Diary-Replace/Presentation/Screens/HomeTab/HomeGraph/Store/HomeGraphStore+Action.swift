//
//  HomeGraphStore+Action.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/29.
//

import Foundation
import ComposableArchitecture

extension HomeGraphStore {
    enum Action: ViewAction {
        case view(ViewAction)
    }
}

extension HomeGraphStore.Action {
    enum ViewAction {
        case graphTapped(String?, isExclusive: Bool = false)
    }
}
