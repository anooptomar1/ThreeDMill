//  Created by dasdom on 10.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import ThreeDMill

class GameViewControllerTests: XCTestCase {
    
    var sut: GameViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = GameViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_view_isGameView() {
        XCTAssertTrue(sut.view is GameView)
    }
}
