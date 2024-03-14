//
//  CalendarStore+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/03/12.
//

import Foundation
import ComposableArchitecture

extension CalendarStore {
    @ObservableState
    struct State: Identifiable, Equatable {
        var id: UUID = UUID()
        let year: Int
        let month: Int
        var calendarModel: CalendarModel
        var dates: [[CalendarCellStore.State]] = []
        var identifiedArray: IdentifiedArrayOf<CalendarCellStore.State> = []
        var forward: (Int, Int) { self.calendarModel.forward() }
        var backward: (Int, Int) { self.calendarModel.backward() }
        
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
            self.calendarModel = .init(year: year, month: month)
            (self.dates, self.identifiedArray) = self.calendarModel.create()
        }
    }
}
