//
//  HomeView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeStore.self)
struct HomeView: View {
    @Bindable var store: StoreOf<HomeStore>
    
    var body: some View {
        NavigationStack {
            ZStack {
                HomeDataListView(store: store.scope(state: \.homeDataListState, action: \.homeDataListAction))
                GeometryReader { _ in
                    footer
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ちいトレ")
                        .foregroundColor(.black)
                        .font(.custom("HanazomeFont", size: 18))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $store.scope(state: \.homeDataInputListState,
                                      action: \.homeDataInputListAction)) { store in
                HomeDataInputListView(store: store)
            }
        }
    }
    
    private var footer: some View {
        Button {
            send(.addDataButtonTapped)
        } label: {
            VStack {
                Asset.kusamushiriLicense.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text("ついか")
                    .foregroundColor(.black)
                    .font(.custom("HanazomeFont", size: 13))
            }
            .padding(10)
            .background(
                Circle()
                    .fill(Asset.green01.swiftUIColor)
            )
            .padding(.trailing)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeStore.State(),
                          reducer: { HomeStore() }))
}
