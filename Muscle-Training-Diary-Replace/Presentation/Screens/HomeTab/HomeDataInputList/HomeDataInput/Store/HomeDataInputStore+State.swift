//
//  HomeDataInputStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import Foundation
import ComposableArchitecture

extension HomeDataInputStore {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: UUID = UUID()
        var base: Base = .init()
        var training: Training = .init()
        var trainingNameSelection: Int = 0
        var view: ViewState {
            .init(isTypingMode: base.isTypingMode,
                  inputModeChangeButtonLabel: base.isTypingMode ? "選択" : "入力",
                  trainingNames: base.trainingNames)
        }
        var focusedField: Field?
        enum Field: String, Hashable, CaseIterable {
            case trainingName
            case weight
            case count
            case setCount
        }
    }
    
    @ObservableState
    struct Base: Equatable {
        var trainingNames: [String] {
            @Dependency(\.storageClient) var stroageClient
            return stroageClient.getTrainingNames()
        }
        var isTypingMode: Bool = false
        var inputModeChangeButtonLabel: String {
            isTypingMode ? "選択" : "入力"
        }

        func with() -> State {
            .init(base: self)
        }
    }
}

extension HomeDataInputStore.State {
    mutating func moveForward() -> Bool {
        guard focusedField != .setCount else { return false }
        focusedField = focusedField?.next()
        return true
    }
    
    mutating func moveBack() -> Bool {
        guard focusedField != .trainingName else { return false }
        if !base.isTypingMode && focusedField == .weight { return false }
        if !base.isTypingMode {
            focusedField = focusedField?.back() == .trainingName ? .weight : focusedField?.back()
            return true
        }
        focusedField = focusedField?.back()
        return true
    }
    
    mutating func focusHeadInitial() {
        focusedField = base.isTypingMode ? .trainingName : .weight
    }
    
    mutating func focusTailInitial() {
        focusedField = .setCount
    }
}

extension HomeDataInputStore {
    struct ViewState {
        let isTypingMode: Bool
        let inputModeChangeButtonLabel: String
        let trainingNames: [String]
    }
}
