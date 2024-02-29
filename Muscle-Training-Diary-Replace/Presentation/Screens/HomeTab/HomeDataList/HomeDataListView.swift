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
        VStack(alignment: .leading) {
            HStack {
                label(image: store.detailStatus.image, text: "最大と前回")
                Spacer()
                sortButton
                    .highPriorityGesture(TapGesture())
            }
            .onTapGesture {
                send(.detailLabelTapped, animation: .smooth)
            }
            .padding(.horizontal)
            if store.detailStatus == .open && searchText.isEmpty {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.fixed(115)), .init(.fixed(115))]) {
                        ForEach(store.trainingDetailList) { detail in
                            NavigationLink(destination: {
                                HomeGraphView(store: Store(initialState: HomeGraphStore.State(trainingDataList: store.trainingDataList.filter { $0.name == detail.name }),
                                                           reducer: { HomeGraphStore() }))
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text(detail.name)
                                            .foregroundColor(.black)
                                            .font(.custom("HanazomeFont", size: 18))
                                    }
                                }
                            }) {
                                HomeDataDetailArea(trainingDetail: detail)
                            }
                        }
                    }
                    .padding()
                }
            }
            label(image: Asset.hachiwareLabel.swiftUIImage, text: "一覧")
                .padding(.horizontal)
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
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("調べる"))
    }
    
    private func label(image: Image, text: String) -> some View {
        HStack {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            Text(text)
        }
        .padding(.horizontal)
    }
    
    private var sortButton: some View {
        Menu {
            Picker("", selection: $store.sort.sending(\.sortChanged)) {
                ForEach(Sort.allCases, id: \.self) {
                    Text($0.label)
                }
            }
        } label: {
            HStack {
                store.sort.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                Text(store.sort.label)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(8)
            .fixedSize()
        }
    }
}

#Preview {
    HomeDataListView(store: Store(initialState: HomeDataListStore.State(trainingDataList: [.fake, .fake, .fake, .feke2]),
                                  reducer: { HomeDataListStore() }))
}
