//
//  HomeDataListView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeDataListStore.self)
struct HomeDataListView: View {
    @Bindable var store: StoreOf<HomeDataListStore>
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            if store.loadStatus == .loading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                        .padding(.bottom)
                    Text("読み込み中")
                }
                .foregroundColor(.black)
            } else {
                content
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Asset.lightGreen.swiftUIColor
        )
        .onAppear {
            send(.onAppear)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    var content: some View {
        List {
            ForEach(store.trainingDataList.filter {
                guard !searchText.isEmpty else { return true }
                return $0.name.contains(searchText)
            }, id: \.id) {
                HomeDataView(training: $0)
                    .padding(.bottom)
                    .tag($0.id)
            }
            .onDelete { offset in
                send(.onDeleteItem(offset))
            }
            .listRowBackground(Asset.lightGreen.swiftUIColor)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("調べる"))
    }
}

#Preview {
    HomeDataListView(store: Store(initialState: HomeDataListStore.State(trainingDataList: [.fake, .fake, .fake]),
                                  reducer: { HomeDataListStore() }))
}
