//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

final class Board {
    
    static let numberOfColumns = 4
    var poles: [[Pole]]
    
    init() {
        poles = []
        for _ in 0..<Board.numberOfColumns {
            var column: [Pole] = []
            for _ in 0..<Board.numberOfColumns {
                column.append(Pole())
            }
            poles.append(column)
        }
    }
}

// MARK: - BoardLogic
extension Board {
    func canAddSphereTo(column: Int, row: Int) -> Bool {
        return poles[column][row].spheres < 4
    }
    
    func canRemoveSphereFrom(column: Int, row: Int) -> Bool {
        return poles[column][row].spheres > 0
    }
    
    func addSphereWith(_ color: SphereColor, toColumn column: Int, andRow row: Int) throws {
        guard canAddSphereTo(column: column, row: row) else {
            throw BoardLogicError.poleFull
        }
        
        poles[column][row].add(color: color)
    }
    
    func removeSphereFrom(column: Int, andRow row: Int) throws {
        guard canRemoveSphereFrom(column: column, row: row) else {
            throw BoardLogicError.poleEmpty
        }
        
        poles[column][row].remove()
    }
}

enum BoardLogicError: Error {
    case poleFull
    case poleEmpty
}
