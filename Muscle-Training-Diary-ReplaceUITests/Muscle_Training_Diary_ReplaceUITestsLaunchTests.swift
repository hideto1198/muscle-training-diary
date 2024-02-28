//
//  Muscle_Training_Diary_ReplaceUITestsLaunchTests.swift
//  Muscle-Training-Diary-ReplaceUITests
//
//  Created by 東　秀斗 on 2024/02/25.
//

import XCTest

final class Muscle_Training_Diary_ReplaceUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
