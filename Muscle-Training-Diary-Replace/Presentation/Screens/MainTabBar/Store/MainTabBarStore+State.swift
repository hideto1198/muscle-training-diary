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
        var currentTab: Tab = .home
        var homeState: HomeStore.State = .init()
        var calendarTabState: CalendarTabStore.State = .init()
    }

    enum Tab: Int {
        case home
        case graph
    }
}
