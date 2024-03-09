//
//  ContentView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        MainTabBarView(store: Store(initialState: MainTabBarStore.State(),
                                    reducer: { MainTabBarStore() }))
    }
}

#Preview {
    ContentView()
}
