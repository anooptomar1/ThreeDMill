//  Created by dasdom on 30.10.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import ThreeDMill

class BoardBehaviourTests: XCTestCase {
    
    var sut: Board!

    override func setUp() {
        super.setUp()

        sut = Board()
    }
    
    override func tearDown() {
        sut = nil

        super.tearDown()
    }
    
    func test_addWhiteSphere_reducesRemainingWhiteSpheres() {
        expectation(forNotification: .numberOfRemainingSpheresChanged, object: nil) { notification -> Bool in
            return true
        }
        
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        
        waitForExpectations(timeout: 0.2) { error in
            print(error ?? "foo")
        }
    }
    
}
