//
//  HomeStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/13.
//

import Foundation
import ComposableArchitecture

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        var loadState: LoadState = .none
        var offsetY: CGFloat = 0
        var dataInputState: DataInputStore.State?
        var trainingDataState = TrainingDataStore.State()
        var chartState: ChartStore.State?
        var isSheetPresented: Bool { chartState !=  nil }

        var trainingDatas: [TrainingData] {
            get { trainingDataState.trainingDatas }
            set {
                trainingDataState.trainingDatas = newValue
            }
        }
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case showAlert
        case fetchTrainingData
        case fetchTrainingDataResponse(TaskResult<[TrainingData]>)
        case onRegistered
        case toHideImage
        case setSheet(isPresented: Bool)
        case dataInputAction(DataInputStore.Action)
        case trainingDataAction(TrainingDataStore.Action)
        case chartAction(ChartStore.Action)
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
                return EffectTask(value: .fetchTrainingData)
            case .showAlert:
                state.dataInputState = DataInputStore.State(trainingNameValues: Array(Set(state.trainingDatas.map{ $0.trainingName })).sorted())
                return .none
            case .fetchTrainingData:
                return .task { [] in
                    await .fetchTrainingDataResponse(TaskResult { try await firebaseClient.fetchTrainingData() })
                }
            case .fetchTrainingDataResponse(.success(let datas)):
                state.trainingDatas = datas
                return .none
            case .fetchTrainingDataResponse(.failure):
                return .none
            case .onRegistered:
                state.offsetY = -1000
                return .concatenate(
                    .run { _ in
                        try await Task.sleep(for: .seconds(2.5))
                    },
                    EffectTask(value: .toHideImage)
                )
            case .toHideImage:
                state.loadState = .none
                state.offsetY = 0
                return .none
            case .setSheet(isPresented: true):
                state.chartState = ChartStore.State(
                    trainingDatas: state.trainingDatas,
                    trainingNames: Array(Set(state.trainingDatas.map{ $0.trainingName }))
                )
                return .none
            case .setSheet(isPresented: false):
                state.chartState = nil
                return .none
            case .dataInputAction(.setTrainingDataResponse):
                state.loadState = .loaded
                return EffectTask(value: Action.fetchTrainingData)
            case .trainingDataAction(.dataInputAction(.setTrainingDataResponse)):
                return EffectTask(value: Action.fetchTrainingData)
            case .dataInputAction(.alertDimiss):
                state.dataInputState = nil
                return .none
            case .dataInputAction:
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
        .ifLet(\.chartState, action: /Action.chartAction) {
            ChartStore()
        }
    }
}
