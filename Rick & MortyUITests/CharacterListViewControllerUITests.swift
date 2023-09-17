import XCTest

class CharacterListViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Instantiate a new instance of XCUIApplication
        app = XCUIApplication()
        
        // Launch the app
        app.launch()
        
        // Continue after failure
        continueAfterFailure = false
    }

    func testDisplayingCharacterList() {
        // Assuming we named the cells using the `accessibilityIdentifier` property
        let firstCharacterCell = app.collectionViews.cells["CharacterCell_0"]
        let secondCharacterCell = app.collectionViews.cells["CharacterCell_1"]
        
        XCTAssertTrue(firstCharacterCell.exists)
        XCTAssertTrue(secondCharacterCell.exists)
    }
    
    func testSelectingCharacterShowsDetails() {
        let firstCharacterCell = app.collectionViews.cells["CharacterCell_0"]
        firstCharacterCell.tap()
        
        let title = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(title.exists)
    }

    func testInfiniteScroll() {
        // Swipe up to paginate
        app.collectionViews.element.swipeUp()
        
        let twentyFirstCharacterCell = app.collectionViews.cells["CharacterCell_20"]
        XCTAssertTrue(twentyFirstCharacterCell.exists)
    }
    
}
