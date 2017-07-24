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
    
    func test_checkForMatch_matches_firstFloor_column0() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 3)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,0,0),(0,1,0),(0,2,0),(0,3,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_column1() {
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 3)

        let result = sut.checkForMatch()
        
        let expectedResult = [(1,0,0),(1,1,0),(1,2,0),(1,3,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_column2() {
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 3)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(2,0,0),(2,1,0),(2,2,0),(2,3,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_column3() {
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(3,0,0),(3,1,0),(3,2,0),(3,3,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_row0() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 0)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,0,0),(1,0,0),(2,0,0),(3,0,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_row1() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 1)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,1,0),(1,1,0),(2,1,0),(3,1,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_row2() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 2)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,2,0),(1,2,0),(2,2,0),(3,2,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_firstFloor_row3() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 3)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 3)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 3)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,3,0),(1,3,0),(2,3,0),(3,3,0)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_thirdFloor_column2() {
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 0)
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 2, andRow: 3)
        try? sut.addSphereWith(.red, toColumn: 2, andRow: 3)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 3)

        
        let result = sut.checkForMatch()
        
        let expectedResult = [(2,0,2),(2,1,2),(2,2,2),(2,3,2)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_secondFloor_row1() {
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 1)
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 1)
        
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,1,1),(1,1,1),(2,1,1),(3,1,1)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_secondFloor_diagonal1() {
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 3)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,0,1),(1,1,1),(2,2,1),(3,3,1)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_secondFloor_diagonal2() {
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 3)
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 0)
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,3,1),(1,2,1),(2,1,1),(3,0,1)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_secondColumn_plane_diagonal1() {
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 1, andRow: 3)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 3)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(1,0,0),(1,1,1),(1,2,2),(1,3,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_secondColumn_plane_diagonal2() {
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 3)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        }
        try? sut.addSphereWith(.red, toColumn: 1, andRow: 0)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(1,3,0),(1,2,1),(1,1,2),(1,0,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_thirdRow_plane_diagonal1() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 2)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 2)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 3, andRow: 2)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,2,0),(1,2,1),(2,2,2),(3,2,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_thirdRow_plane_diagonal2() {
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 2)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 0, andRow: 2)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 2)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(3,2,0),(2,2,1),(1,2,2),(0,2,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_room_diagonal1() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 3)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,0,0),(1,1,1),(2,2,2),(3,3,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_room_diagonal2() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 3)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        }
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 0)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 3, andRow: 0)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(0,3,0),(1,2,1),(2,1,2),(3,0,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_room_diagonal3() {
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 0)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        }
        try? sut.addSphereWith(.red, toColumn: 0, andRow: 3)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 3)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(3,0,0),(2,1,1),(1,2,2),(0,3,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_matches_room_diagonal4() {
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        for _ in 0..<2 {
            try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        }
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        }
        try? sut.addSphereWith(.red, toColumn: 0, andRow: 0)
        for _ in 0..<3 {
            try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        }
        
        let result = sut.checkForMatch()
        
        let expectedResult = [(3,3,0),(2,2,1),(1,1,2),(0,0,3)]
        assertEqual(result, expectedResult)
    }
    
    func test_checkForMatch_firstFloor_column_performance() {
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 0, andRow: 2)
        try? sut.addSphereWith(.red, toColumn: 0, andRow: 3)

        try? sut.addSphereWith(.white, toColumn: 1, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 1, andRow: 2)
        try? sut.addSphereWith(.red, toColumn: 1, andRow: 3)
        
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 0)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 1)
        try? sut.addSphereWith(.white, toColumn: 2, andRow: 2)
        try? sut.addSphereWith(.red, toColumn: 2, andRow: 3)
        
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 0)
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 1)
        try? sut.addSphereWith(.red, toColumn: 3, andRow: 2)
        try? sut.addSphereWith(.white, toColumn: 3, andRow: 3)
        
        measure {
            _ = sut.checkForMatch()
        }
    }
}

extension BoardLogicTests {
    func assertEqual(_ first: [(Int,Int,Int)]?, _ second: [(Int,Int,Int)]?, file: StaticString = #file, line: UInt = #line) {
        guard let first = first else { return XCTFail("First is nil", file: file, line: line) }
        guard let second = second else { return XCTFail("Second is nil", file: file, line: line) }
        for i in 0..<first.count {
            XCTAssertEqual(first[i].0, second[i].0, "first: \(first[i]), second: \(second[i])", file: file, line: line)
            XCTAssertEqual(first[i].1, second[i].1, "first: \(first[i]), second: \(second[i])", file: file, line: line)
            XCTAssertEqual(first[i].2, second[i].2, "first: \(first[i]), second: \(second[i])", file: file, line: line)
        }
    }
}
