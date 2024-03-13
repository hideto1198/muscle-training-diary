//
//  Int+Extension.swift
//  Muscle-Training-Diary-ReplaceTests
//
//  Created by 東　秀斗 on 2024/03/10.
//

import XCTest
import Muscle_Training_Diary_Replace

final class Int_Extension: XCTestCase {
    func testIsLeapYear() {
        XCTAssert(2004.isLeapYear)
        XCTAssert(2008.isLeapYear)
        XCTAssert(2012.isLeapYear)
        XCTAssert(2016.isLeapYear)
        XCTAssert(2020.isLeapYear)
        XCTAssert(2024.isLeapYear)
        
        XCTAssertFalse(2023.isLeapYear)
        XCTAssertFalse(2100.isLeapYear)
        XCTAssertFalse(2200.isLeapYear)
        XCTAssertFalse(2000.isLeapYear)
        XCTAssertFalse(2300.isLeapYear)
    }
}
