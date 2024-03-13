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
        let year: Int
        let month: Int
        public let entity: DateEntity
        public var date: Date {
            let dateFormatter = DateFormatter.fullDate
            return dateFormatter.date(from: "\(year)年\(month)月\(entity.date)日 00:00:00")!
        }
        public var hasData: Bool = false
        var loadStauts: LoadStatus = .none
        var isTapped: Bool = false
    }
}

typealias CalendarCellStoreList = [CalendarCellStore.State]
extension CalendarCellStoreList {
    var identifiableArray: IdentifiedArrayOf<CalendarCellStore.State> {
        IdentifiedArray(uniqueElements:  self)
    }
}
