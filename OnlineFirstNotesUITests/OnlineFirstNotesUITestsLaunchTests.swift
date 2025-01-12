//
//  OnlineFirstNotesUITestsLaunchTests.swift
//  OnlineFirstNotesUITests
//
//  Created by Darul Firmansyah on 11/01/25.
//

import XCTest

final class OnlineFirstNotesUITestsLaunchTests: XCTestCase {
    
    var app: XCUIApplication?

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func tearDownWithError() throws { //Does this each time it ends the test
        app = nil //Makes sure that the test wont have residual values, it will be torn down each time the funcion has finished
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication() // Initializes the XCTest app
        app?.launch() // Launches the app
    }

    @MainActor
    func testAddTask() {
        // Given: The main task list is displayed
        let app = XCUIApplication()
        
        // When: The user taps the "Add Task" button
        XCTAssertTrue(app.buttons["LIST_ADD_BTN"].exists)
        app.buttons["LIST_ADD_BTN"].tap()
        XCTAssertTrue(app.staticTexts["Add Task"].exists)
    }
}
