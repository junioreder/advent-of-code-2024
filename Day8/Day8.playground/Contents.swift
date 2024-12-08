import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        print("Starting...")
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let lines = inputText.split(separator: "\n")
        
        var antennas: [Character: [Position]] = [:]
        var antennasList: Set<Position> = []
        
        var width = 0
        let height = lines.count
        
        var boardPositions: [[Character]] = Array(
            repeating: Array(repeating: ".", count: lines[0].count),
            count: lines.count
        )
        
        for y in 0..<lines.count {
            let line = lines[y]
            
            if width == 0 {
                width = line.count
            }
            for (x, character) in line.enumerated() {
                if character == "." {
                    continue
                }
                boardPositions[x][y] = character
                antennasList.insert(Position(x: x, y: y))
                if antennas[character] == nil {
                    antennas[character] = [Position(x: x, y: y)]
                } else {
                    antennas[character]?.append(Position(x: x, y: y))
                }
            }
        }
        
        var partOneAntinodes: Set<Position> = []
        var partTwoAntinodes: Set<Position> = []
        var partTwoAntennasWithSignal: Set<Position> = []
        var linesWithAntiNode: Set<Int> = []
        
        for antennaSignal in antennas.keys {
            var positions = antennas[antennaSignal]!
            for i in 0..<positions.count {
                for j in i+1..<positions.count {
                    
                    let previous = positions[i]
                    let current = positions[j]
                                        
                    var topItem = current.y < previous.y ? current : previous
                    let bottomItem = current.y > previous.y ? current : previous
                    let distanceY = bottomItem.y - topItem.y
                    let distanceX = max(topItem.x, bottomItem.x) - min(topItem.x, bottomItem.x)
                                        
                    let topSignalY = topItem.y - distanceY
                    if topSignalY >= 0 {
                        var shouldSumX = topItem.x > bottomItem.x
                        let topSignalX = shouldSumX ? topItem.x + distanceX : topItem.x - distanceX
                        
                        if topSignalX >= 0 && topSignalX < width {
                            let antiNode = Position(x: topSignalX, y: topSignalY)
                                                        
                            partOneAntinodes.insert(antiNode)
                            partTwoAntinodes.insert(antiNode)
                            linesWithAntiNode.insert(antiNode.y)
                            
                            if boardPositions[topSignalX][topSignalY] != "." {
                                partTwoAntennasWithSignal.insert(antiNode)
                            }
                            
                            var currentPositionX = antiNode.x
                            var currentPositionY = antiNode.y
                            while true {
                                currentPositionY -= distanceY
                                
                                if currentPositionY < 0 {
                                    break
                                }
                                
                                currentPositionX = shouldSumX ? currentPositionX + distanceX : currentPositionX - distanceX
                                
                                if currentPositionX < 0 || currentPositionX >= width {
                                    break
                                }
                                partTwoAntinodes.insert(Position(x: currentPositionX, y: currentPositionY))
                                linesWithAntiNode.insert(currentPositionY)
                                if boardPositions[currentPositionX][currentPositionY] != "." {
                                    partTwoAntennasWithSignal.insert(Position(x: currentPositionX, y: currentPositionY))
                                }
                            }
                        }
                    }
                    
                    let bottomSignalY = bottomItem.y + distanceY
                    
                    if bottomSignalY < height {
                        var shouldSumX = bottomItem.x > topItem.x
                        
                        let bottomSignalX = shouldSumX ? bottomItem.x + distanceX : bottomItem.x - distanceX
                        
                        if bottomSignalX >= 0 && bottomSignalX < height {
                            let antiNode = Position(x: bottomSignalX, y: bottomSignalY)
                            
                            partOneAntinodes.insert(antiNode)
                            partTwoAntinodes.insert(antiNode)
                            linesWithAntiNode.insert(antiNode.y)
                            
                            if boardPositions[bottomSignalX][bottomSignalY] != "." {
                                partTwoAntennasWithSignal.insert(antiNode)
                            }
                            
                            var currentPositionX = antiNode.x
                            var currentPositionY = antiNode.y
                            while true {
                                currentPositionY += distanceY
                                
                                if currentPositionY >= height {
                                    break
                                }
                                
                                currentPositionX = shouldSumX ? currentPositionX + distanceX : currentPositionX - distanceX
                                
                                if currentPositionX < 0 || currentPositionX >= width {
                                    break
                                }
                                partTwoAntinodes.insert(Position(x: currentPositionX, y: currentPositionY))
                                linesWithAntiNode.insert(currentPositionY)
                                if boardPositions[currentPositionX][currentPositionY] != "." {
                                    partTwoAntennasWithSignal.insert(Position(x: currentPositionX, y: currentPositionY))
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        var antennasInSameLineWithAntiNodeCount: Int = 0
        for antena in antennasList {
            if !partTwoAntennasWithSignal.contains(antena) {
                if linesWithAntiNode.contains(antena.y) {
                    antennasInSameLineWithAntiNodeCount += 1
                }
            }
        }
        
        print("AntiNodes partOne count: \(partOneAntinodes.count)")
        
        print("AntennasWith antiNodes count: \(partTwoAntinodes.count + antennasInSameLineWithAntiNodeCount)")
    } catch {
        print("Error: \(error)")
    }
} else {
    print("Input file not found.")
}
