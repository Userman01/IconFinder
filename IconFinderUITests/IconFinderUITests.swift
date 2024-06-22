//
//  IconFinderUITests.swift
//  IconFinderUITests
//
//  Created by Петр Постников on 19.06.2024.
//

import XCTest

final class IconFinderUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testTabBarItem() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.buttons["ГЛАВНАЯ"].exists)
        
        tabBar.tap()
    }
    
    func testTabBarItem2() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.buttons["ИЗБРАННЫЕ"].exists)
        
        tabBar.tap()
    }
}
