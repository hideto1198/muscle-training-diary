//
//  HomeStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeStore {
    @Dependency(\.firebaseClient) var firebaseClient
    @Dependency(\.storageClient) var storageClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .buttonTapped:
                    return .run { _ in
                        let datas = try await firebaseClient.fetchTrainingData()
                        
                    } catch: { error, send in
                        fatalError(error.localizedDescription)
                    }
                case .saveButtonTapped:
                    print(storageClient.getTrainingNames())
                    return .none
                case .addDataButtonTapped:
                    state.homeDataInputListState = .init()
                    return .none
                }
            case .homeDataInputListAction(.presented(.saveDone)):
                return .run { send in
                    await send(.trainingDataReceived(Result { try await firebaseClient.fetchTrainingData() }))
                }
            case .trainingDataReceived(.success(let trainingDataList)):
                state.homeDataListState.trainingDataList = trainingDataList
                state.homeDataListState.homeDataList = IdentifiedArray(uniqueElements: trainingDataList.map { HomeDataStore.State(training: $0) })
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$homeDataInputListState, action: \.homeDataInputListAction) {
            HomeDataInputListStore()
        }
        Scope(state: \.homeDataListState, action: \.homeDataListAction) {
            HomeDataListStore()
        }
    }
}
