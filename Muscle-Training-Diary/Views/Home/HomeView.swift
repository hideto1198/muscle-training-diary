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
            ZStack {
                TabView {
                    grid
                        .tabItem {
                            Image(systemName: "house")
                            Text("ホーム")
                        }
                        .onAppear {
                            viewStore.send(.onAppear)
                        }
                    chart
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("グラフ")
                        }
                    if UserDefaults.standard.string(forKey: "userId") == "12E4EBF9-A4AF-4D95-9FF1-E2D6E27E49C4" {
                        chat
                            .tabItem {
                                Image(systemName: "message")
                                Text("チャット")
                            }
                    }
                }
                if viewStore.loadState == .loading {
                    ProgressView("通信中")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }

    }

    private var chat: some View {
        ChatView(store: store.scope(state: \.chatState, action: HomeStore.Action.chatAction))
    }

    @State private var gridHeight: CGFloat = .zero
    private var grid: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                 ZStack {
                    ScrollView {
                        if viewStore.searchText.isEmpty {
                            homeGrid
                        } else {
                            VStack(alignment: .leading) {
                                ForEach(viewStore.trainingDatas.filter{ $0.trainingName.contains(viewStore.searchText) }, id: \.self) { trainingDataValue in
                                    trainingData(data: trainingDataValue)
                                        .onTapGesture {
                                            viewStore.send(.onEdit(trainingDataValue))
                                        }
                                    Divider()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                        }
                    }
                    .padding(.horizontal, 5)
                    .searchable(text: viewStore.binding(\.$searchText))
                    .searchSuggestions {
                        Section("検索結果") {
                            ForEach(viewStore.trainingDatas.filter{ $0.trainingName.contains(viewStore.searchText) }, id: \.self) {
                                trainingData(data: $0)
                            }
                        }
                    }
                    .navigationTitle("筋トレ日記")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            sortPatternMenu
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            gridStyleMenu
                        }
                    }
                     if viewStore.searchText.isEmpty {
                         dataInputView
                     }
                     alert
                     if viewStore.loadState == .loaded {
                         Text("")
                             .onAppear {
                                 viewStore.send(.onRegistered, animation: .easeOut(duration: 2.5))
                             }
                     }
                }
            }
        }
    }

    private var alert: some View {
        IfLetStore(store.scope(state: \.dataEditState,
                               action: HomeStore.Action.dataInputAction),
                   then: { store in
                        DataInputView(store: store)
                    }
        )
    }

    private var homeGrid: some View {
        WithViewStore(store) { viewStore in
            LazyVGrid(columns: viewStore.gridStyle.columns) {
                ForEach(convert(trainingDatas: viewStore.trainingDatas, viewStore.sortPattern), id: \.self) { date in
                    NavigationLink(destination: content(date: date)) {
                        GeometryReader { geometry in
                            Text(date)
                                .font(.system(size: 20, weight: .heavy))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal, 5)
                                .frame(height: geometry.size.width)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20).stroke()
                                )
                                .background(
                                    Path { _ in
                                        gridHeight = geometry.size.width
                                    }
                                )
                                .background(Color("backColor").cornerRadius(20))
                                .foregroundColor(Color.primary)
                        }
                        .frame(height: gridHeight)
                    }
                }
                .padding(5)
            }
            .padding(5)
        }
    }

    private var sortPatternMenu: some View {
        WithViewStore(store) { viewStore in
            Menu("並び順") {
                Button(
                    action: {
                        viewStore.send(.setSortStyle(.orderedAscending), animation: .easeInOut)
                    },
                    label: {
                        if viewStore.sortPattern == .orderedAscending {
                            Label("昇順", systemImage: "checkmark")
                        } else {
                            Text("昇順")
                        }
                    }
                )
                Button(
                    action: {
                        viewStore.send(.setSortStyle(.orderedDescending), animation: .easeInOut)
                    },
                    label: {
                        if viewStore.sortPattern == .orderedDescending {
                            Label("降順", systemImage: "checkmark")
                        } else {
                            Text("降順")
                        }
                    }
                )
            }
        }
    }

    private var gridStyleMenu: some View {
        WithViewStore(store) { viewStore in
            Menu("表示スタイル") {
                ForEach(GridStyle.allCases) { gridStyle in
                    Button(
                        action: {
                            viewStore.send(.setColumns(gridStyle), animation: .easeInOut)
                        },
                        label: {
                            if viewStore.gridStyle == gridStyle {
                                Label(gridStyle.lable, systemImage: "checkmark")
                            } else {
                                Label(gridStyle.lable, systemImage: gridStyle.rawValue)
                            }
                        }
                    )
                }
            }
        }
    }

    private func content(date: String) -> some View {
        WithViewStore(store) { viewStore in
            ZStack {
                List {
                    ForEach(sorted(trainingDatas: viewStore.trainingDatas.filter { $0.trainingDate!.contains(date) }), id: \.self) { date in
                        NavigationLink(destination: trainingDataView(trainingData: date)) {
                            Text(date)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("backColor"))
            .navigationTitle(date)
            .navigationBarTitleDisplayMode(.inline)

        }
    }

    private func trainingData(data: TrainingData) -> some View {
        VStack(alignment: .leading) {
            if let trainingDate = data.trainingDate {
                Text(trainingDate)
            }
            Text(data.trainingName)
                .bold()
            if String(format: "%.2f", data.weight) != "0.00" {
                HStack {
                    Text(String(format: "%.2f", data.weight))
                    Text(data.valueUnit.label)
                }
                .font(.system(size: 20))
            }
            setCountView(data: data)
            memoView(memo: data.memo)
        }
    }

    private var dataInputView: some View {
        WithViewStore(store) { viewStore in
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
        }
    }

    private var chart: some View {
        IfLetStore(store.scope(state: \.chartState,
                               action: HomeStore.Action.chartAction)) {
            ChartView(store: $0)
        }
    }

    private func trainingDataView(trainingData: String) -> some View {
        TrainingDataView(store: store.scope(state: \.trainingDataState, action: HomeStore.Action.trainingDataAction),
                         trainingData: trainingData)
    }

    private func setCountView(data: TrainingData) -> some View {
        Group {
            if data.count == 0 {
                EmptyView()
            } else {
                Text("\(data.count) × \(data.setCount)セット")
                    .font(.system(size: 20))
            }
        }
    }

    private func memoView(memo: String) -> some View {
        Group {
            if memo == "" {
                EmptyView()
            } else {
                Text("メモ")
                    .font(.system(size: 16))
                Text(memo)
                    .font(.system(size: 20))
                    .padding(.leading)
            }
        }
    }
}

extension HomeView {
    private func sorted(trainingDatas: [TrainingData]) -> Array<String> {
        var result: [String] = []
        result = Array(Set(trainingDatas.map { $0.trainingDate!.components(separatedBy: " ")[0] }))
        result = result.sorted(by: { compare($0, $1) })
        return result
    }

    private func compare(_ ldate: String, _ rdate: String) -> Bool {
        let dateFormatter = dateFormatter(dateFormat: "yyyy年MM月dd日")
        return dateFormatter.date(from: ldate)?.compare(dateFormatter.date(from: rdate)!) == .orderedAscending
    }

    private func convert(trainingDatas: [TrainingData], _ sortPattern: ComparisonResult) -> Array<String> {
        var result: [String] = []
        let dateFormatter = dateFormatter(dateFormat: "yyyy年MM月")
        result = Array(Set(trainingDatas.map { $0.trainingDate!.components(separatedBy: "月")[0] + "月" }))
        result = result.sorted(by: { dateFormatter.date(from: $0)?.compare(dateFormatter.date(from: $1)!) == sortPattern })
        return result
    }

    private func dateFormatter(dateFormat: String) -> DateFormatter {
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = dateFormat
            dateFormatter.locale = Locale(identifier: "ja_JP")
            return dateFormatter
        }

        return dateFormatter
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: .init(),
                              reducer: HomeStore()))
    }
}
