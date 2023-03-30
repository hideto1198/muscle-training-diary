//
//  HomeView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeStore>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ZStack {
                    List(sorted(trainingDatas: viewStore.trainingDatas), id: \.self) { date in
                        NavigationLink(destination: trainingDataView(trainingData: date)) {
                            Text(date)
                        }
                    }
                    .listStyle(.plain)
                    IfLetStore(store.scope(state: \.dataInputState,
                                           action: HomeStore.Action.dataInputAction),
                               then: { store in
                                    DataInputView(store: store)
                                }, else: {
                                    VStack(alignment: .trailing) {
                                        Spacer()
                                        Button(action: {
                                            viewStore.send(.showAlert, animation: .easeInOut)
                                        }, label: {
                                            Image( viewStore.loadState == .loaded ? "chiikabu2" : "chiikabu1")
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .offset(y: viewStore.offsetY)
                                        })
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                    )
                    if viewStore.loadState == .loaded {
                        Text("")
                            .onAppear {
                                viewStore.send(.onRegistered, animation: .easeOut(duration: 2.5))
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("backColor"))
                .navigationTitle("筋トレ日記")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button(
                            action: {
                                viewStore.send(.setSheet(isPresented: true))
                            },
                            label: {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                            }
                        )
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.isSheetPresented, send: HomeStore.Action.setSheet(isPresented:))) {
                IfLetStore(store.scope(state: \.chartState,
                                       action: HomeStore.Action.chartAction)) {
                    ChartView(store: $0)
                }
            }
        }
    }

    private func sorted(trainingDatas: [TrainingData]) -> Array<String> {
        var result: [String] = []
        result = Array(Set(trainingDatas.map { $0.trainingDate!.components(separatedBy: " ")[0] }))
        result = result.sorted(by: { compare($0, $1) })
        return result
    }

    private func compare(_ ldate: String, _ rdate: String) -> Bool {
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            return dateFormatter
        }

        return dateFormatter.date(from: ldate)?.compare(dateFormatter.date(from: rdate)!) == .orderedAscending
    }

    private func trainingDataView(trainingData: String) -> some View {
        TrainingDataView(store: store.scope(state: \.trainingDataState, action: HomeStore.Action.trainingDataAction),
                         trainingData: trainingData)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: .init(),
                              reducer: HomeStore()))
    }
}
