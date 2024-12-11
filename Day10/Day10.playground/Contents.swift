import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
}

func parseInputFile(_ filePath: String) -> (trailPositionMap: [Int: [Position]], width: Int, height: Int) {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        var trailPositionMap: [Int: [Position]] = [:]
        
        let lines = inputText.split(separator: "\n")
        
        guard lines.count > 0 && lines[0].count > 0 else {
            return ([:], 0, 0)
        }
        
        for (y, values) in lines.enumerated() {
            for (x, value) in values.compactMap({Int($0)}).enumerated() {
                let positionValue = Position(x: x, y: y)
                if trailPositionMap[value] != nil {
                    trailPositionMap[value]?.append(positionValue)
                } else {
                    trailPositionMap[value] = [positionValue]
                }
            }
        }
        
        return (trailPositionMap, lines[0].count, lines.count)
    } catch {
        print("Error reading input file: \(error)")
        return ([:], 0, 0)
    }
}

func getCurrentValue(trailPositionMap: [Int: [Position]], currentPosition: Position) -> Int? {
    for trailPositionKey in trailPositionMap.keys {
        let trailPosition = trailPositionMap[trailPositionKey]!
        
        if trailPosition.contains(currentPosition) {
            return trailPositionKey
        }
    }
    
    return nil
}

func getNextPositions(in trailPositionMap: [Int: [Position]], width: Int, height: Int, around currentPosition: Position, withValue value: Int) -> [Position] {
    guard let positionList = trailPositionMap[value] else {
        return []
    }
    
    var nextPositions: [Position] = []
    
    if currentPosition.y > 0 {
        let topPosition = Position(x: currentPosition.x, y: currentPosition.y - 1)
        if positionList.contains(topPosition) {
            nextPositions.append(topPosition)
        }
    }
    
    if currentPosition.x > 0 {
        let leftPosition = Position(x: currentPosition.x - 1, y: currentPosition.y)
        if positionList.contains(leftPosition) {
            nextPositions.append(leftPosition)
        }
    }
    
    if currentPosition.y < (height - 1) {
        let bottomPosition = Position(x: currentPosition.x, y: currentPosition.y + 1)
        if positionList.contains(bottomPosition) {
            nextPositions.append(bottomPosition)
        }
    }
    
    if currentPosition.x < (width - 1) {
        let rightPosition = Position(x: currentPosition.x + 1, y: currentPosition.y)
        if positionList.contains(rightPosition) {
            nextPositions.append(rightPosition)
        }
    }
    
    return nextPositions
}


func calculateTrailScore(trailPositionMap: [Int: [Position]], width: Int, height: Int, currentPosition: Position, currentValue: Int, reachedNine: inout [Position]) {
    
    guard let ninePositions = trailPositionMap[9] else {
        return
    }

    if currentValue == 9 && ninePositions.contains(currentPosition) {
        reachedNine.append(currentPosition)
        return
    }
    
    let nextValue = currentValue + 1
    
    let nextPositionList = getNextPositions(in: trailPositionMap, width: width, height: height, around: currentPosition, withValue: nextValue)
    
    for nextPosition in nextPositionList {
        calculateTrailScore(trailPositionMap: trailPositionMap, width: width, height: height, currentPosition: nextPosition, currentValue: nextValue, reachedNine: &reachedNine)
    }
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    print("Starting...")
    
    let (trailPositionMap, width, height) = parseInputFile(filePath)
    
    
    var pathCountPartOne = 0
    var pathCountPartTwo = 0
    if let startOfTrailList = trailPositionMap[0] {
        
        for startOfTrail in startOfTrailList {
            var reachedNine: [Position] = []
            
            calculateTrailScore(trailPositionMap: trailPositionMap, width: width, height: height, currentPosition: startOfTrail, currentValue: 0, reachedNine: &reachedNine)
            
            pathCountPartOne += Set(reachedNine).count
            pathCountPartTwo += reachedNine.count
        }
    }
    
    print("Trailhead score partOne: \(pathCountPartOne)")
    print("Trailhead score partTwo: \(pathCountPartTwo)")
} else {
    print("Input file not found.")
}


extension Int {
    init?(_ element: Substring.Element) {
        if let value = Int(String(element)) {
            self = value
        } else {
            self = -1
        }
    }
}
