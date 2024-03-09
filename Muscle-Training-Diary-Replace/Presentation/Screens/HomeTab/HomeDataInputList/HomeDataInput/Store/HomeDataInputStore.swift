//
//  HomeDataInputStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeDataInputStore {
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    guard let trainingName = state.base.trainingNames.first else {
                        state.base.isTypingMode = true
                        return .none
                    }
                    if state.trainingNameSelection != 0 {
                        state.training.name = state.base.trainingNames[state.trainingNameSelection]
                        return .none
                    }
                    state.training.name = trainingName
                    return .none
                case .inputModeChangeButtonTapped:
                    state.base.isTypingMode.toggle()
                    if state.training.name.isEmpty {
                        state.training.name = state.base.trainingNames[state.trainingNameSelection]
                    }
                    return .none
                case .trashButtonTapped:
                    return .none
                case .textEditorTapped(let field):
                    state.focusedField = field
                    return .none
                }
            case .binding(\.trainingNameSelection):
                state.training.name = state.base.trainingNames[state.trainingNameSelection]
                return .none
            case .binding:
                return .none
            }
        }
    }
}
