//
//  HomeDataListStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeDataListStore {
    @Dependency(\.firebaseClient) var firebaseClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    state.loadStatus = .loading
                    return .run { send in
                        await send(.trainingDataReceived(Result { try await firebaseClient.fetchTrainingData() }))
                    }
                case .onDeleteItem(let indexSet):
                    state.alert = .OkAndCancel(okLabel: "する",
                                               cancelLabel: "しない",
                                               message: "データ削除しちゃうのっ！？") {
                        .okButtonTapped(indexSet)
                    }
                    return .none
                }
            case .trainingDataReceived(.success(let trainingDataList)):
                state.loadStatus = .loaded
                state.trainingDataList = trainingDataList
                state.homeDataList = IdentifiedArray(uniqueElements: trainingDataList.map { HomeDataStore.State(training: $0) })
                return .none
            case .alert(.presented(.okButtonTapped(let indexSet))):
                guard let index = indexSet.first else { return .none }
                return .run { [trainingData = state.trainingDataList[index]] send in
                    try await firebaseClient.deleteTrainingData(trainingData.data)
                    await send(.trainingDataReceived(Result { try await firebaseClient.fetchTrainingData() }))
                }
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.homeDataList, action: \.homeDataAction) {
            HomeDataStore()
        }
    }
}
