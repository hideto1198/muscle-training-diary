//
//  HomeDataStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation
import ComposableArchitecture

extension HomeDataStore {
    @ObservableState
    struct State: Identifiable, Hashable {
        var id: UUID = UUID()
        var training: Training
    }
}
