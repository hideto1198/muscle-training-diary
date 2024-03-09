//
//  HomeStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeStore {
    @ObservableState
    struct State {
        var base: Base = .init()

        var homeDataListState: HomeDataListStore.State = .init()
        @Presents var homeDataInputListState: HomeDataInputListStore.State?
    }
    
    struct Base {
        func with() -> State {
            .init(base: self)
        }
    }
}

// MARK: - View
extension HomeStore {
    struct ViewState {
    }
}
