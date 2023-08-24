//
//  HomeStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import Foundation
import SwiftUI
import ComposableArchitecture

extension ComparisonResult: Codable {}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var searchText: String = ""
        var loadState: LoadState = .none
        var offsetY: CGFloat = 0
        var dataInputState: DataInputStore.State?
        var dataEditState: DataInputStore.State?
        var trainingDataState = TrainingDataStore.State()
        var chatState = ChatStore.State()
        var chartState: ChartStore.State?
        var isSheetPresented: Bool { chartState !=  nil }
        var homeWatchConnection = HomeWatchConnection()
        
        var trainingDatas: [TrainingData] {
            get { trainingDataState.trainingDatas }
            set { trainingDataState.trainingDatas = newValue }
        }

        var sortPattern: ComparisonResult = .orderedDescending
        var gridStyle: GridStyle = .two
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case showAlert
        case fetchTrainingData
        case fetchTrainingDataResponse(TaskResult<[TrainingData]>)
        case onRegistered
        case toHideImage
        case dataInputAction(DataInputStore.Action)
        case dataEditAction(DataInputStore.Action)
        case trainingDataAction(TrainingDataStore.Action)
        case chatAction(ChatStore.Action)
        case chartAction(ChartStore.Action)
        case setColumns(GridStyle)
        case setSortStyle(ComparisonResult)
        case onEdit(TrainingData)
        case listen
        case listenedValue(TaskResult<[Message]>)
        case sendToWatch
    }

    @Dependency(\.firebaseClient) var firebaseClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Scope(state: \.trainingDataState, action: /Action.trainingDataAction) {
            TrainingDataStore()
        }
        Scope(state: \.chatState, action: /Action.chatAction) {
            ChatStore()
        }
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                if let gridStyle = UserDefaults.standard.decodedObject(GridStyle.self, forKey: "gridStyle") {
                    state.gridStyle = gridStyle
                }
                if let sortPattern = UserDefaults.standard.decodedObject(ComparisonResult.self, forKey: "sortPattern") {
                    state.sortPattern = sortPattern
                }
                return .merge(
                    EffectTask(value: .fetchTrainingData),
                    EffectTask(value: .chatAction(.onAppear)),
                    EffectTask(value: .listen)
                )
            case .listen:
                return .run { send in
                    for try await value in try await firebaseClient.listen() {
                        await send(.listenedValue(.success(value)))
                    }
                } catch: { error, send in
                    await send(.listenedValue(.failure(error)))
                }
            case .listenedValue(.success(let values)):
                return EffectTask(value: .chatAction(.receive(values)))
            case .listenedValue(.failure(let error)):
                print(error)
                return .none
            case .showAlert:
                state.dataInputState = DataInputStore.State(trainingNameValues: Array(Set(state.trainingDatas.map{ $0.trainingName })).sorted())
                return .none
            case .fetchTrainingData:
                state.loadState = .loading
                return .task { [] in
                    await .fetchTrainingDataResponse(TaskResult { try await firebaseClient.fetchTrainingData() })
                }
            case .fetchTrainingDataResponse(.success(let datas)):
                state.loadState = .none
                state.trainingDatas = datas
                state.chartState = ChartStore.State(
                    trainingDatas: state.trainingDatas,
                    trainingNames: Array(Set(state.trainingDatas.map{ $0.trainingName }))
                )
                return EffectTask(value: .sendToWatch)
            case .sendToWatch:
                var sendData: [String: [[String: Any]]] = [:]
                let currentDatas = state.trainingDatas
                let groupedDatas = Dictionary(grouping: currentDatas) { data -> String in
                    data.trainingName
                }
                groupedDatas.forEach {
                    sendData[$0.key] = $0.value.map { $0.toDict }
                }
                state.homeWatchConnection.sendData(trainingData: sendData)
                return .none
            case .fetchTrainingDataResponse(.failure):
                state.loadState = .none
                return .none
            case .onRegistered:
                state.offsetY = -1000
                return .concatenate(
                    .run { _ in
                        try await Task.sleep(for: .seconds(2))
                    },
                    EffectTask(value: .toHideImage)
                )
            case .toHideImage:
                state.loadState = .none
                state.offsetY = 0
                return .none
            case .setColumns(let gridStyle):
                state.gridStyle = gridStyle
                UserDefaults.standard.setEncoded(gridStyle, forKey: "gridStyle")
                return .none
            case .setSortStyle(let comparisonResult):
                state.sortPattern = comparisonResult
                UserDefaults.standard.setEncoded(comparisonResult, forKey: "sortPattern")
                return .none
            case .dataInputAction(.setTrainingDataResponse):
                state.loadState = .loaded
                return EffectTask(value: Action.fetchTrainingData)
            case .trainingDataAction(.dataInputAction(.setTrainingDataResponse)):
                return EffectTask(value: Action.fetchTrainingData)
            case .trainingDataAction(.deleteTrainingDataResponse):
                return EffectTask(value: Action.fetchTrainingData)
            case .dataInputAction(.alertDimiss):
                state.dataInputState = nil
                return .none
            case .onEdit(let data):
                state.dataEditState = DataInputStore.State(trainingNameValues: Array(Set(state.trainingDatas.map{ $0.trainingName })))
                return EffectTask(value: Action.dataEditAction(.onEdit(data)))
            case .dataInputAction:
                return .none
            case .dataEditAction(.alertDimiss):
                state.dataEditState = nil
                return .none
            case .dataEditAction:
                return .none
            case .trainingDataAction:
                return .none
            case .chartAction:
                return .none
            case .chatAction:
                return .none
            }
        }
        .ifLet(\.dataInputState, action: /Action.dataInputAction) {
            DataInputStore()
        }
        .ifLet(\.dataEditState, action: /Action.dataEditAction) {
            DataInputStore()
        }
        .ifLet(\.chartState, action: /Action.chartAction) {
            ChartStore()
        }
    }
}

extension HomeStore {
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

        return dateFormatter.date(from: ldate)! <= dateFormatter.date(from: rdate)!
    }
}
