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
        var chartState: ChartStore.State?
        var isSheetPresented: Bool { chartState !=  nil }

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
        case chartAction(ChartStore.Action)
        case setColumns(GridStyle)
        case setSortStyle(ComparisonResult)
        case onEdit(TrainingData)
    }

    @Dependency(\.firebaseClient) var firebaseClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Scope(state: \.trainingDataState, action: /Action.trainingDataAction) {
            TrainingDataStore()
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
                return EffectTask(value: .fetchTrainingData)
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
