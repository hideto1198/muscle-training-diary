//
//  CalendarCellStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/13.
//

import Foundation
import ComposableArchitecture

extension CalendarCellStore {
    @ObservableState
    public struct State: Identifiable {
        public var id: UUID = UUID()
        public let entity: DateEntity
    }
}

typealias CalendarCellStoreList = [CalendarCellStore.State]
extension CalendarCellStoreList {
    var identifiableArray: IdentifiedArrayOf<CalendarCellStore.State> {
        IdentifiedArray(uniqueElements:  self)
    }
}
