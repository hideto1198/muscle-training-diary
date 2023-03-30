//
//  DataInputStore.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/03/26.
//

import Foundation
import ComposableArchitecture


enum InputType: Equatable {
    case write
    case select

    func reverse() -> Self {
        switch self {
        case .write: return .select
        case .select: return .write
        }
    }
}

struct DataInputStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var trainingName: String = ""
        @BindingState var weight: String = ""
        @BindingState var memo: String = ""
        @BindingState var currentUnit: ValueUnit = .minutes
        @BindingState var count: Int = 0
        @BindingState var setCount: Int = 0
        var trainingNameValues: [String] = []
        @BindingState var trainingNameValueIndex: Int = 0
        var currentInputType: InputType {
            get {
                trainingNameValues.isEmpty ? .write : inputType
            }
        }
        var inputType: InputType = .select
        var trainingDate: String?
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setTrainignData
        case setTrainingDataResponse(TaskResult<Bool>)
        case onEdit(TrainingData)
        case updateInputType
        case alertDimiss
    }

    @Dependency(\.firebaseClient) var firebaseClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .setTrainignData:
                if !state.trainingNameValues.isEmpty && state.trainingName == "" {
                    state.trainingName = state.trainingNameValues[state.trainingNameValueIndex]
                }
                guard (state.weight != "" || state.memo != "") && state.trainingName != "" else { return .none }
                guard let weight = Double(state.weight == "" ? "0" : state.weight ) else { return EffectTask(value: .alertDimiss) }
                let trainingData = TrainingData(trainingDate: state.trainingDate,
                                                trainingName: state.trainingName,
                                                weight: weight,
                                                valueUnit: state.currentUnit,
                                                count: state.count,
                                                setCount: state.setCount,
                                                memo: state.memo)
                return .task { [trainingData = trainingData] in
                        await .setTrainingDataResponse(TaskResult { try await firebaseClient.setTrainingData(trainingData) })
                    }
            case .setTrainingDataResponse:
                return EffectTask(value: Action.alertDimiss)
            case .onEdit(let trainingData):
                if !state.trainingNameValues.isEmpty {
                    state.trainingNameValueIndex = state.trainingNameValues.firstIndex(of: trainingData.trainingName) ?? 0
                }
                state.trainingName = trainingData.trainingName
                state.weight = "\(trainingData.weight)"
                state.memo = trainingData.memo
                state.currentUnit = trainingData.valueUnit
                state.count = trainingData.count
                state.setCount = trainingData.setCount
                state.trainingDate = trainingData.trainingDate
                return .none
            case .updateInputType:
                state.inputType = state.inputType.reverse()
                return .none
            case .alertDimiss:
                state.trainingName = ""
                state.weight = ""
                state.memo = ""
                state.trainingDate = nil
                return .none
            }
        }
    }
}
