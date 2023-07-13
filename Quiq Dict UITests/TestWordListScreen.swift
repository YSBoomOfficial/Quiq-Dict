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

        XCTAssert(cellTitle.exists, "Cell Title Should Appear")
        XCTAssert(cellSubtitle.exists, "Cell Subtitle Should Appear")

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
        XCTAssert(table.staticTexts["Hello /həˈləʊ/"].exists, "Title Should Appear")

        // Headings
        XCTAssert(table.staticTexts["Phonetics"].exists, "Phonetics Heading Should Appear")
        XCTAssert(table.staticTexts["Meanings"].exists, "Meanings Heading Should Appear")
        XCTAssert(table.staticTexts["License: CC BY-SA 3.0"].exists, "License Heading Should Appear")
        XCTAssert(table.staticTexts["Source URLs"].exists, "Source URLs Heading Should Appear")

        // Audio Title
        XCTAssert(table.staticTexts["AU N/a"].exists, "Audio Title AU Should Appear")
        XCTAssert(table.staticTexts["UK /həˈləʊ/"].exists, "Audio Title UK Should Appear")
        XCTAssert(table.staticTexts["/həˈloʊ/"].exists, "Audio Title Should Appear")
        XCTAssert(table.staticTexts["Audio Unavailable"].exists, "Audio Unavailable Title Should Appear")

        // Audio Licences
        XCTAssert(table.staticTexts["License: BY-SA 4.0"].exists, "First Audio License Should Appear")
        XCTAssert(table.staticTexts["License: BY 3.0 US"].exists, "Second Audio License Should Appear")

        // Audio Buttons
        XCTAssertEqual(table.buttons.matching(identifier: "volume highest").count, 2, "There Should be 2 Audio buttons")

        // Links
        XCTAssertEqual(table.buttons.matching(.init(format: "identifier CONTAINS 'link_'")).count, 4, "There shoudld be 4 links")

        // Subheadings
        XCTAssert(table.staticTexts["Part of Speech: Noun"].exists, "Part of Speech: Noun Should Appear")
        XCTAssert(table.staticTexts["Part of Speech: Verb"].exists, "Part of Speech: Verb Should Appear")
        XCTAssert(table.staticTexts["Part of Speech: Interjection"].exists, "Part of Speech: Interjection Should Appear")
        XCTAssertEqual(table.cells.staticTexts.matching(identifier: "Definitions:").count, 3)
        XCTAssert(table.staticTexts["General Synonyms:"].exists, "General Synonyms Should Appear")
        XCTAssert(table.staticTexts["General Antonyms:"].exists, "General Antonyms Should Appear")

        // Definition (-) and Examples (Example:)
        XCTAssertEqual(table.staticTexts.matching(.init(format: "identifier CONTAINS 'definition_'")).count, 7, "There shoudld be 7 definition texts")
        XCTAssertEqual(table.staticTexts.matching(.init(format: "identifier CONTAINS 'example_'")).count, 5, "There shoudld be 5 example texts")

    }

}
