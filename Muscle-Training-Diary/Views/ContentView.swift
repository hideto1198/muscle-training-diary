//
//  ContentView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("backColor"))
    }

    var body: some View {
        HomeView(store: Store(initialState: .init(),
                              reducer: HomeStore()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
