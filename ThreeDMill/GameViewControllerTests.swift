//  Created by dasdom on 10.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import ThreeDMill
import SceneKit

class GameViewControllerTests: XCTestCase {
    
    var sut: GameViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = GameViewController()
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_view_isGameView() {
        XCTAssertTrue(sut.view is GameView)
    }
    
    func test_add_callsAddOfView() {
        let mockView = MockGameView(frame: .zero)
        sut.view = mockView
        let button = UIButton(type: .system)
        button.tag = 0
        
        sut.add(sender: button)
        
        XCTAssertEqual(mockView.sphereColor, SphereColor.red)
    }
    
    func test_numberOfSpheresChangedNotification_changesNumberOfRemainingSpheres() {
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        NotificationCenter.default.post(name: .numberOfRemainingSpheresChanged, object: nil, userInfo: [SphereColor.red: 23, SphereColor.white: 5])
        
        XCTAssertEqual(sut.contentView.remainingRedSpheresLabel.text, "23")
        XCTAssertEqual(sut.contentView.remainingWhiteSpheresLabel.text, "5")
    }
}

// MARK: - Mocks
extension GameViewControllerTests {
    class MockGameView: GameView {
        
        var sphereColor: SphereColor?
        
        override func add(color: SphereColor) {
            sphereColor = color
        }
        
        
    }
}
