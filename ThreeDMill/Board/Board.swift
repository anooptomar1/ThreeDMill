//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let numberOfRemainingSpheresChanged = Notification.Name("numberOfRemainingSpheresChanged")
}

enum BoardMode {
    case addSpheres
    case removeSphere
    case game
}

final class Board {
    
    static let numberOfColumns = 4
    var mode = BoardMode.addSpheres
    private var poles: [[Pole]]
    private var remainingWhiteSpheres = 32
    private var remainingRedSpheres = 32
    
    private var seenMills: [String] = []
    
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
       
        switch color {
        case .red:
            remainingRedSpheres -= 1
        case .white:
            remainingWhiteSpheres -= 1
        }
        
        NotificationCenter.default.post(name: .numberOfRemainingSpheresChanged, object: nil, userInfo: [SphereColor.white: remainingWhiteSpheres, SphereColor.red: remainingRedSpheres])
    }
    
    func removeSphereFrom(column: Int, andRow row: Int) throws {
        guard canRemoveSphereFrom(column: column, row: row) else {
            throw BoardLogicError.poleEmpty
        }
        
        print("removeSphereFrom: column: \(column), row: \(row)")
        print("pole: \(poles[column][row].spheres)")
        poles[column][row].remove()
        print("pole: \(poles[column][row].spheres)")
    }
    
    func spheresAt(column: Int, row: Int) -> Int {
        return poles[column][row].spheres
    }
    
    func sphereColorAt(column: Int, row: Int, floor: Int) -> SphereColor? {
        let pole = poles[column][row]
        guard pole.spheres > floor else { return nil }
        return poles[column][row].sphereColors[floor]
    }
    
    func checkForMatch() -> [(Int, Int, Int)]? {
//        var result: [(Int,Int,Int)]? = checkForColumn()
        let functions = [checkForColumn,
                         checkForRow,
                         checkForFloorDiagonal1,
                         checkForFloorDiagonal2,
                         checkForColumnDiagonal1,
                         checkForColumnDiagonal2,
                         checkForRowDiagonal1,
                         checkForRowDiagonal2,
                         checkForPole,
                         checkForRoomDiagonal1,
                         checkForRoomDiagonal2,
                         checkForRoomDiagonal3,
                         checkForRoomDiagonal4]
        
        var result : [(Int,Int,Int)]? = nil
        var tempSeenMills: [String] = []
        for check in functions {
            if result == nil {
                result = check()
                if let unwrappedResult = result {
                    let resultString = unwrappedResult.reduce("", {
                        return $0 + "\($1.0)\($1.1)\($1.2)"
                    })
                    print("resultString: \(resultString)")
                 
                    if seenMills.contains(resultString) {
                        tempSeenMills.append(resultString)
                        result = nil
                    } else {
                        tempSeenMills.append(resultString)
                        break
                    }
                }
            }
        }
        seenMills = tempSeenMills
        
        return result
    }
    
    func checkForColumn() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        floorLoop: for floor in 0..<Board.numberOfColumns {
            columnLoop: for column in 0..<Board.numberOfColumns {
                result = []
                rowLoop: for row in 0..<Board.numberOfColumns {
                    if firstColor == nil {
                        firstColor = sphereColorAt(column: column, row: row, floor: floor)
                        guard firstColor != nil else {
                            result = nil
                            break rowLoop
                        }
                        result?.append((column,row,floor))
                    } else {
                        let color = sphereColorAt(column: column, row: row, floor: floor)
                        if color == firstColor {
                            result?.append((column,row,floor))
                        } else {
                            firstColor = nil
                            result = nil
                            break rowLoop
                        }
                    }
                }
                if result != nil {
                    break floorLoop
                }
            }
        }
        return result
    }
    
    func checkForRow() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        floorLoop: for floor in 0..<Board.numberOfColumns {
            rowLoop: for row in 0..<Board.numberOfColumns {
                result = []
                columnLoop: for column in 0..<Board.numberOfColumns {
                    if firstColor == nil {
                        firstColor = sphereColorAt(column: column, row: row, floor: floor)
                        guard firstColor != nil else {
                            result = nil
                            break columnLoop
                        }
                        result?.append((column,row,floor))
                    } else {
                        let color = sphereColorAt(column: column, row: row, floor: floor)
                        if color == firstColor {
                            result?.append((column,row,floor))
                        } else {
                            firstColor = nil
                            result = nil
                            break columnLoop
                        }
                    }
                }
                if result != nil {
                    break floorLoop
                }
            }
        }
        return result
    }
    
    func checkForFloorDiagonal1() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        floorLoop: for floor in 0..<Board.numberOfColumns {
            result = []
            rowLoop: for row in 0..<Board.numberOfColumns {
                if firstColor == nil {
                    firstColor = sphereColorAt(column: row, row: row, floor: floor)
                    guard firstColor != nil else {
                        result = nil
                        break rowLoop
                    }
                    result?.append((row,row,floor))
                } else {
                    let color = sphereColorAt(column: row, row: row, floor: floor)
                    if color == firstColor {
                        result?.append((row,row,floor))
                    } else {
                        firstColor = nil
                        result = nil
                        break rowLoop
                    }
                }
            }
            if result != nil {
                break floorLoop
            }
        }
        return result
    }
    
    func checkForFloorDiagonal2() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        floorLoop: for floor in 0..<Board.numberOfColumns {
            result = []
            rowLoop: for column in 0..<Board.numberOfColumns {
                let row = Board.numberOfColumns - 1 - column
                if firstColor == nil {
                    firstColor = sphereColorAt(column: column, row: row, floor: floor)
                    guard firstColor != nil else {
                        result = nil
                        break rowLoop
                    }
                    result?.append((column,row,floor))
                } else {
                    let color = sphereColorAt(column: column, row: row, floor: floor)
                    if color == firstColor {
                        result?.append((column,row,floor))
                    } else {
                        firstColor = nil
                        result = nil
                        break rowLoop
                    }
                }
            }
            if result != nil {
                break floorLoop
            }
        }
        return result
    }
    
    func checkForColumnDiagonal1() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        columnLoop: for column in 0..<Board.numberOfColumns {
            result = []
            rowLoop: for row in 0..<Board.numberOfColumns {
                if firstColor == nil {
                    firstColor = sphereColorAt(column: column, row: row, floor: row)
                    guard firstColor != nil else {
                        result = nil
                        break rowLoop
                    }
                    result?.append((column,row,row))
                } else {
                    let color = sphereColorAt(column: column, row: row, floor: row)
                    if color == firstColor {
                        result?.append((column,row,row))
                    } else {
                        firstColor = nil
                        result = nil
                        break rowLoop
                    }
                }
            }
            if result != nil {
                break columnLoop
            }
        }
        return result
    }
    
    func checkForColumnDiagonal2() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        columnLoop: for column in 0..<Board.numberOfColumns {
            result = []
            floorLoop: for floor in 0..<Board.numberOfColumns {
                let row = Board.numberOfColumns - 1 - floor
                if firstColor == nil {
                    firstColor = sphereColorAt(column: column, row: row, floor: floor)
                    guard firstColor != nil else {
                        result = nil
                        break floorLoop
                    }
                    result?.append((column,row,floor))
                } else {
                    let color = sphereColorAt(column: column, row: row, floor: floor)
                    if color == firstColor {
                        result?.append((column,row,floor))
                    } else {
                        firstColor = nil
                        result = nil
                        break floorLoop
                    }
                }
            }
            if result != nil {
                break columnLoop
            }
        }
        return result
    }
    
    func checkForRowDiagonal1() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        rowLoop: for row in 0..<Board.numberOfColumns {
            result = []
            columnLoop: for column in 0..<Board.numberOfColumns {
                if firstColor == nil {
                    firstColor = sphereColorAt(column: column, row: row, floor: column)
                    guard firstColor != nil else {
                        result = nil
                        break columnLoop
                    }
                    result?.append((column,row,column))
                } else {
                    let color = sphereColorAt(column: column, row: row, floor: column)
                    if color == firstColor {
                        result?.append((column,row,column))
                    } else {
                        firstColor = nil
                        result = nil
                        break columnLoop
                    }
                }
            }
            if result != nil {
                break rowLoop
            }
        }
        return result
    }
    
    func checkForRowDiagonal2() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        columnLoop: for row in 0..<Board.numberOfColumns {
            result = []
            floorLoop: for floor in 0..<Board.numberOfColumns {
                let column = Board.numberOfColumns - 1 - floor
                if firstColor == nil {
                    firstColor = sphereColorAt(column: column, row: row, floor: floor)
                    guard firstColor != nil else {
                        result = nil
                        break floorLoop
                    }
                    result?.append((column,row,floor))
                } else {
                    let color = sphereColorAt(column: column, row: row, floor: floor)
                    if color == firstColor {
                        result?.append((column,row,floor))
                    } else {
                        firstColor = nil
                        result = nil
                        break floorLoop
                    }
                }
            }
            if result != nil {
                break columnLoop
            }
        }
        return result
    }
    
    func checkForPole() -> [(Int, Int, Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        rowLoop: for row in 0..<Board.numberOfColumns {
            columnLoop: for column in 0..<Board.numberOfColumns {
                result = []
                floorLoop: for floor in 0..<Board.numberOfColumns {
                    if firstColor == nil {
                        firstColor = sphereColorAt(column: column, row: row, floor: floor)
                        guard firstColor != nil else {
                            result = nil
                            break floorLoop
                        }
                        result?.append((column,row,floor))
                    } else {
                        let color = sphereColorAt(column: column, row: row, floor: floor)
                        if color == firstColor {
                            result?.append((column,row,floor))
                        } else {
                            firstColor = nil
                            result = nil
                            break floorLoop
                        }
                    }
                }
                if result != nil {
                    break rowLoop
                }
            }
        }
        return result
    }
    
    func checkForRoomDiagonal1() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        columnLoop: for column in 0..<Board.numberOfColumns {
            if firstColor == nil {
                firstColor = sphereColorAt(column: column, row: column, floor: column)
                guard firstColor != nil else {
                    result = nil
                    break columnLoop
                }
                result?.append((column,column,column))
            } else {
                let color = sphereColorAt(column: column, row: column, floor: column)
                if color == firstColor {
                    result?.append((column,column,column))
                } else {
                    firstColor = nil
                    result = nil
                    break columnLoop
                }
            }
        }
        return result
    }
    
    func checkForRoomDiagonal2() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        columnLoop: for column in 0..<Board.numberOfColumns {
            let row = Board.numberOfColumns - 1 - column
            if firstColor == nil {
                firstColor = sphereColorAt(column: column, row: row, floor: column)
                guard firstColor != nil else {
                    result = nil
                    break columnLoop
                }
                result?.append((column,row,column))
            } else {
                let color = sphereColorAt(column: column, row: row, floor: column)
                if color == firstColor {
                    result?.append((column,row,column))
                } else {
                    firstColor = nil
                    result = nil
                    break columnLoop
                }
            }
        }
        return result
    }
    
    func checkForRoomDiagonal3() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        rowLoop: for row in 0..<Board.numberOfColumns {
            let column = Board.numberOfColumns - 1 - row
            if firstColor == nil {
                firstColor = sphereColorAt(column: column, row: row, floor: row)
                guard firstColor != nil else {
                    result = nil
                    break rowLoop
                }
                result?.append((column,row,row))
            } else {
                let color = sphereColorAt(column: column, row: row, floor: row)
                if color == firstColor {
                    result?.append((column,row,row))
                } else {
                    firstColor = nil
                    result = nil
                    break rowLoop
                }
            }
        }
        return result
    }
    
    func checkForRoomDiagonal4() -> [(Int,Int,Int)]? {
        var result: [(Int,Int,Int)]? = []
        var firstColor: SphereColor?
        floorLoop: for floor in 0..<Board.numberOfColumns {
            let column = Board.numberOfColumns - 1 - floor
            if firstColor == nil {
                firstColor = sphereColorAt(column: column, row: column, floor: floor)
                guard firstColor != nil else {
                    result = nil
                    break floorLoop
                }
                result?.append((column,column,floor))
            } else {
                let color = sphereColorAt(column: column, row: column, floor: floor)
                if color == firstColor {
                    result?.append((column,column,floor))
                } else {
                    firstColor = nil
                    result = nil
                    break floorLoop
                }
            }
        }
        return result
    }
    
    enum BoardLogicError: Error {
        case poleFull
        case poleEmpty
    }
}
