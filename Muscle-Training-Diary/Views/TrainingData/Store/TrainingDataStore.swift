//
//  TrainingDataStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/26.
//

import Foundation
import ComposableArchitecture

struct TrainingDataStore: ReducerProtocol {
    struct State: Equatable {
        var trainingDatas: [TrainingData] = []
        var dataInputState: DataInputStore.State?
    }

    enum Action: Equatable {
        case onEdit(TrainingData)
        case deleteTrainingData(TrainingData)
        case deleteTrainingDataResponse(TaskResult<Bool>)
        case dataInputAction(DataInputStore.Action)
    }

    @Dependency(\.firebaseClient) var firebaseClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onEdit(let data):
                state.dataInputState = DataInputStore.State(trainingNameValues: Array(Set(state.trainingDatas.map{ $0.trainingName })))
                return EffectTask(value: Action.dataInputAction(.onEdit(data)))
            case .deleteTrainingData(let data):
                return .task { [data = data] in
                    await .deleteTrainingDataResponse(TaskResult { try await firebaseClient.deleteTrainingData(data) })
                }
            case .deleteTrainingDataResponse(.success):
                return .none
            case .deleteTrainingDataResponse(.failure):
                return .none
            case .dataInputAction(.alertDimiss):
                state.dataInputState = nil
                return .none
            case .dataInputAction:
                return .none
            }
        }
        .ifLet(\.dataInputState, action: /Action.dataInputAction) {
            DataInputStore()
        }
    }
}
