//
//  MainTabBarView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: MainTabBarStore.self)
struct MainTabBarView: View {
    typealias Tab = MainTabBarStore.Tab
    @Bindable var store: StoreOf<MainTabBarStore>
    
    var body: some View {
        TabView(selection: $store.currentTab) {
            HomeView(store: store.scope(state: \.homeState, action: \.homeAction))
                .background(Asset.lightGreen.swiftUIColor)
                .tag(Tab.home.rawValue)
                .tabItem {
                    Asset.chiikawaHouse.swiftUIImage
                    Text("ほーむ")
                }
            Text("グラフを表示する")
                .font(.custom("HanazomeFont", size: 16))
                .background(Asset.lightGreen.swiftUIColor)
                .tag(Tab.graph.rawValue)
                .tabItem {
                    Asset.pajamaPartys.swiftUIImage
                    Text("ぐらふ")
                }
        }
        .tint(.black)
        .onAppear {
            UITabBar.appearance().barTintColor = Asset.lightGreen.color
        }
    }
}

#Preview {
    MainTabBarView(store: Store(initialState: MainTabBarStore.State(),
                                reducer: { MainTabBarStore() }))
}
