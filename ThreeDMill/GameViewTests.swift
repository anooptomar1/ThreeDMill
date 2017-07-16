//  Created by dasdom on 16.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import ThreeDMill

class GameViewTests: XCTestCase {
    
    var sut: GameView!
    
    override func setUp() {
        super.setUp()

        sut = GameView(frame: .zero, options: nil)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func test_addSphere_addsSphere() {
        let button = UIButton()
        button.tag = 1
        
        sut.add(sender: button)
        
        let node = sut.scene?.rootNode.childNode(withName: "Sphere", recursively: true)
        XCTAssertNotNil(node)
    }
    
    func test_addSphere_addsMovingSphere() {
        let button = UIButton()
        button.tag = 1
        
        sut.add(sender: button)
        
        let nodes = sut.scene?.rootNode.childNodes(passingTest: { node, stop -> Bool in
            guard let gameSphereNode = node as? GameSphereNode else { return false }
            return gameSphereNode.isMoving
        })
        XCTAssertEqual(nodes?.count, 1)
    }
}
