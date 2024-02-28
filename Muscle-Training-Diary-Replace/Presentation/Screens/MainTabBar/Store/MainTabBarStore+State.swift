//
//  MainTabBarStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension MainTabBarStore {
    @ObservableState
    struct State {
        var base: Base = .init()
        var view: ViewState {
            .init()
        }
        
        // ChildState
        var homeState: HomeStore.State {
            get { base.homeState.with() }
            set { base.homeState = newValue.base }
        }
        
        var currentTab: Tab = .home
        @Presents var homeDataInputListState: HomeDataInputListStore.State?
    }
    
    struct Base {
        var homeState: HomeStore.Base = .init()
    }
    
    enum Tab: Int {
        case home
        case graph
    }
}

// MARK: - View
extension MainTabBarStore {
    struct ViewState {
    }
}
