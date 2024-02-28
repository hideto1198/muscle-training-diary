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
        HomeView(store: Store(initialState: HomeStore.State(),
                              reducer: { HomeStore() }))
    }
}

#Preview {
    ContentView()
}
