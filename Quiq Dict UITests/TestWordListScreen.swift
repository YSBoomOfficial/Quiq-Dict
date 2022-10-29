//
//  TestWordListScreen.swift
//  Quiq Dict UITests
//
//  Created by Yash Shah on 29/10/2022.
//

import XCTest
@testable import Quiq_Dict

final class TestWordListScreen: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = .init()
        #warning("🔨 - Inject Networking Mock instaed of using the actual network (use launchArguments & launchEnvironment)")
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func test_cell_shows_correct_text_when_search_for_hello() {
        // SearchField
        let searchField = app.navigationBars["Quiq Dict"].searchFields["Search for a word..."]
        searchField.tap()
        searchField.typeText("Hello")

        // TableViewCell
        let cells = app.tables.cells
        XCTAssert(cells.element.waitForExistence(timeout: 5), "Cell Should appear")

        XCTAssertEqual(cells.count, 1, "There should be only 1 cell")
        let cellTitle = cells.containing(.staticText, identifier: "Hello /həˈləʊ/").element
        let cellSubtitle = cells.containing(.staticText, identifier: "\"Hello!\" or an equivalent greeting.").element

        XCTAssert(cellTitle.exists)
        XCTAssert(cellSubtitle.exists)

    }

    func test_detail_cell_shows_correct_data() {
        // SearchField
        let searchField = app.navigationBars["Quiq Dict"].searchFields["Search for a word..."]
        searchField.tap()
        searchField.typeText("Hello")

        // TableViewCell
        let helloCell = app.tables.cells.element
        XCTAssert(helloCell.waitForExistence(timeout: 5), "Cell Should appear")
        helloCell.tap()

        let table = app.tables

        // Title
        XCTAssert(table.staticTexts["Hello /həˈləʊ/"].exists)

        // Headings
        XCTAssert(table.staticTexts["Phonetics"].exists)
        XCTAssert(table.staticTexts["Meanings"].exists)
        XCTAssert(table.staticTexts["License: CC BY-SA 3.0"].exists)
        XCTAssert(table.staticTexts["Source URLs"].exists)

        // Audio Title
        XCTAssert(table.staticTexts["AU N/a"].exists)
        XCTAssert(table.staticTexts["UK /həˈləʊ/"].exists)
        XCTAssert(table.staticTexts["/həˈloʊ/"].exists)
        XCTAssert(table.staticTexts["Audio Unavailable"].exists)

        // Audio Licences
        XCTAssert(table.staticTexts["License: BY-SA 4.0"].exists)
        XCTAssert(table.staticTexts["License: BY 3.0 US"].exists)

        // Audio Buttons
        XCTAssertEqual(table.buttons.matching(identifier: "volume highest").count, 2)

        // Links
        XCTAssertEqual(table.buttons.matching(.init(format: "identifier CONTAINS 'link_'")).count, 4)

        // Subheadings
        XCTAssert(table.staticTexts["Part of Speech: Noun"].exists)
        XCTAssert(table.staticTexts["Part of Speech: Verb"].exists)
        XCTAssert(table.staticTexts["Part of Speech: Interjection"].exists)
        XCTAssertEqual(table.cells.staticTexts.matching(identifier: "Definitions:").count, 3)
        XCTAssert(table.staticTexts["General Synonyms:"].exists)
        XCTAssert(table.staticTexts["General Antonyms:"].exists)

        // Definition (-) and Examples (Example:)
        XCTAssertEqual(table.staticTexts.matching(.init(format: "identifier CONTAINS 'definition_'")).count, 7)
        XCTAssertEqual(table.staticTexts.matching(.init(format: "identifier CONTAINS 'example_'")).count, 5)

    }

}
