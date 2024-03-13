//
//  CalendarCellStore.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CalendarCellStore {
    @Dependency(\.firebaseClient) var firebaseClient
    enum CancelID { case appearing }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .receivedData(let status):
                state.hasData = status
                state.loadStauts = .loaded
                return .none
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    guard !state.entity.date.isEmpty else { return .none }
                    state.loadStauts = .loading
                    return .run { [date = state.date] send in
                        await send(.receivedData(try await firebaseClient.hasData(date)))
                    }
                    .cancellable(id: CancelID.appearing)
                case .onTapped:
                    state.isTapped.toggle()
                    return .none
                case .onDisappear:
                    return .cancel(id: CancelID.appearing)
                }
            }
        }
    }
}
