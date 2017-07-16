//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import ThreeDMill

class BoardLogicTests: XCTestCase {
    
    var sut: Board!
    
    override func setUp() {
        super.setUp()
        
        sut = Board()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_canAddSphereTo_succees() {
        let canAddSphere = sut.canAddSphereTo(column: 0, row: 0)
        XCTAssertTrue(canAddSphere)
    }
    
    func test_canAddSphereTo_fails() {
        do {
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        } catch {
            XCTFail()
        }
        
        let canAddSphere = sut.canAddSphereTo(column: 1, row: 0)
        XCTAssertFalse(canAddSphere)
    }
    
    func test_addSphereWith_onlyAddsFourSpheres() {
        do {
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        } catch {
            XCTFail()
        }
        
        var catchedError: Error?
        do {
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        } catch {
            catchedError = error
        }
        
        XCTAssertNotNil(catchedError)
    }
    
    func test_removeSphereFrom() {
        do {
            try sut.addSphereWith(.white, toColumn: 1, andRow: 0)
            try sut.removeSphereFrom(column: 1, andRow: 0)
        } catch {
            XCTFail()
        }
        
        var catchedError: Error?
        do {
            try sut.removeSphereFrom(column: 1, andRow: 0)
        } catch {
            catchedError = error
        }
        
        XCTAssertNotNil(catchedError)
    }
}
