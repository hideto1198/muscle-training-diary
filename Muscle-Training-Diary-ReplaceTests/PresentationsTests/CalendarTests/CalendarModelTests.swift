//
//  CalendarModelTests.swift
//  Muscle-Training-Diary-ReplaceTests
//
//  Created by 東　秀斗 on 2024/03/10.
//

import XCTest
import Muscle_Training_Diary_Replace

final class CalendarModelTests: XCTestCase {
    func testCreateCalendar() {
        var calendarModel = CalendarModel(year: 2024, month: 3)
        
        XCTAssert(calendarModel.year == 2024)
        
        calendarModel.month = 1
        calendarModel.forward()
        XCTAssert(calendarModel.month == 2)
        calendarModel.backward()
        XCTAssert(calendarModel.month == 1)
        calendarModel.backward()
        XCTAssert(calendarModel.month == 12)
        XCTAssert(calendarModel.year == 2023)
        calendarModel.month = 12
        calendarModel.forward()
        XCTAssert(calendarModel.month == 1)
        XCTAssert(calendarModel.year == 2024)
    }
}
