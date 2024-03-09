//
//  MainTabBarStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainTabBarStore {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        Scope(state: \.homeState, action: \.homeAction) {
            HomeStore()
        }
    }
}
