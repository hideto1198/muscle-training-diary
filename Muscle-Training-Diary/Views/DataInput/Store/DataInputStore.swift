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
        @BindingState var count: String = ""
        @BindingState var setCount: String = ""

        var trainingNameValues: [String] = []
        @BindingState var trainingNameValueIndex: Int = 0
        var currentInputType: InputType {
            get {
                trainingNameValues.isEmpty ? .write : inputType
            }
        }
        var inputType: InputType = .select
        var trainingDate: String?

        @BindingState var focusedField: Field?

        enum Field: String, Hashable {
            case weight, memo
        }
    }

    enum Action: BindableAction, Equatable {
        case onAppear
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
            case .onAppear:
                state.focusedField = .weight
                return .none
            case .binding:
                return .none
            case .setTrainignData:
                state.focusedField = nil
                if !state.trainingNameValues.isEmpty && state.trainingName == "" {
                    state.trainingName = state.trainingNameValues[state.trainingNameValueIndex]
                }
                guard state.trainingName != "" else { return .none }
                guard let weight = Double(state.weight == "" ? "0" : state.weight ),
                      let count = Int(state.count == "" ? "0" : state.count),
                      let setCount = Int(state.setCount == "" ? "0" : state.setCount)
                else { return EffectTask(value: .alertDimiss) }
                let trainingData = TrainingData(trainingDate: state.trainingDate,
                                                trainingName: state.trainingName,
                                                weight: weight,
                                                valueUnit: state.currentUnit,
                                                count: count,
                                                setCount: setCount,
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
                state.count = "\(trainingData.count)"
                state.setCount = "\(trainingData.setCount)"
                state.trainingDate = trainingData.trainingDate
                return .none
            case .updateInputType:
                state.inputType = state.inputType.reverse()
                return .none
            case .alertDimiss:
                state.focusedField = nil
                state.trainingName = ""
                state.weight = ""
                state.memo = ""
                state.trainingDate = nil
                return .none
            }
        }
    }
}
