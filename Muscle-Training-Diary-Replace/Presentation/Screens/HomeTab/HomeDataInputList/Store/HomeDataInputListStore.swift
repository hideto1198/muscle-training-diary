//
//  HomeDataInputListStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeDataInputListStore {
    @Dependency(\.firebaseClient) var firebaseClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .addInputData:
                    if state.homeDataInputStateList.isEmpty {
                        state.homeDataInputStateList.append(.init(base: .init()))
                    } else {
                        guard let selection = state.homeDataInputStateList.last?.trainingNameSelection else { return .none }
                        state.homeDataInputStateList.append(.init(base: .init(), trainingNameSelection: selection))
                    }
                    return .none
                case .keyboardClose:
                    guard let index = state.homeDataInputStateList.firstIndex(where: { $0.focusedField != nil }) else { return .none }
                    state.homeDataInputStateList[index].focusedField = nil
                    return .none
                case .rightSwiped:
                    guard let index = state.homeDataInputStateList.firstIndex(where: { $0.focusedField != nil }) else { return .none }
                    if !state.homeDataInputStateList[index].moveBack() {
                        guard index != state.homeDataInputStateList.startIndex else { return .none }
                        state.homeDataInputStateList[index - 1].focusTailInitial()
                    }
                    return .none
                case .leftSwiped:
                    guard let index = state.homeDataInputStateList.firstIndex(where: { $0.focusedField != nil }) else { return .none }
                    if !state.homeDataInputStateList[index].moveForward() {
                        guard index != state.homeDataInputStateList.endIndex - 1 else { return .none }
                        state.homeDataInputStateList[index + 1].focusHeadInitial()
                    }
                    return .none
                case .saveButtonTapped:
                    return .run { [trainingDataList = state.homeDataInputStateList.filter { !$0.training.error }.map { $0.training }] send in
                        try trainingDataList.forEach {
                            try firebaseClient.saveTrainingData($0.data)
                        }
                        await send(.saveDone)
                    }
                case .dismissModal:
                    guard !state.homeDataInputStateList.isEmpty else {
                        return .run { _ in
                            await dismiss()
                        }
                    }
                    state.alert = .OkAndCancel(okLabel: "うん", cancelLabel: "いやっ", message: "わぁっわぁわわぁ") {
                        .okButtonTapped
                    }
                    return .none
                }
            case .alert(.presented(.okButtonTapped)):
                return .run { _ in
                    await dismiss()
                }
            case .homeDataInputActions(.element(id: let id, action: let action)):
                switch action {
                case .view(.trashButtonTapped):
                    state.homeDataInputStateList.remove(id: id)
                    return .none
                default:
                    return .none
                }
            case .saveDone:
                state.homeDataInputStateList.removeAll(where: { !$0.training.error })
                return .none
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.homeDataInputStateList, action: \.homeDataInputActions) {
            HomeDataInputStore()
        }
    }
}
