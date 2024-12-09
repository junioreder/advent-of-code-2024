import Foundation

func calculateCheckSumPartOne(blocks: [[Int]]) -> Int128 {
    var sum: Int128 = 0
    var currentIndex: Int128 = 0

    for block in blocks {
        for value in block where value >= 0 {
            sum += Int128(value) * currentIndex
            currentIndex += 1
        }
    }
    return sum
}

func calculateCheckSumPartTwo(blocks: [[Int]]) -> Int128 {
    var sum: Int128 = 0
    var currentIndex: Int128 = 0

    for block in blocks {
        for value in block {
            if value >= 0 {
                sum += Int128(value) * currentIndex
            }
            currentIndex += 1
        }
    }
    return sum
}

func parseInputFile(_ filePath: String) -> ([[Int]],[Int:Int]) {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        let numberArray = inputText.compactMap { Int(String($0)) }
        
        var blocks: [[Int]] = []
        var id = 0
        var freeSpaces: [Int: Int] = [:]
        
        for (index, currentNumber) in numberArray.enumerated() {            
            let block: [Int] = Array(repeating: index % 2 == 0 ? id : -1, count: currentNumber)
            blocks.append(block)
            if index % 2 == 0 {
                id += 1
            } else {
                freeSpaces[index] = currentNumber
            }
        }
        return (blocks, freeSpaces)
    } catch {
        print("Error reading input file: \(error)")
        return ([],[:])
    }
}



func processBlocksPartOne(blocks: [[Int]]) -> [[Int]] {
    var blocks = blocks
    var endIndex = blocks.count - 1
    var endBlock = blocks[endIndex]
    var endCharIndex = endBlock.lastIndex(where: { $0 != -1 }) ?? -1
    
    var isEnd = false

    for (startIndex, startBlock) in blocks.enumerated() {
        guard !isEnd, endIndex >= startIndex else { break }
        guard !startBlock.isEmpty, startBlock[0] == -1 else { continue }

        for positionIndex in 0..<startBlock.count where blocks[startIndex][positionIndex] == -1 {
            while endIndex >= startIndex {
                guard endCharIndex >= 0 else {
                    endIndex -= 1
                    endBlock = blocks[endIndex]
                    endCharIndex = endBlock.lastIndex(where: { $0 != -1 }) ?? -1
                    continue
                }
                
                guard blocks[endIndex][endCharIndex] != -1 else {
                    endCharIndex -= 1
                    continue
                }

                if endIndex == startIndex && endCharIndex <= positionIndex {
                    isEnd = true
                    break
                }
                
                blocks[startIndex][positionIndex] = blocks[endIndex][endCharIndex]
                blocks[endIndex][endCharIndex] = -1
                break
            }
        }
    }
    
    return blocks
}

func processBlocksPartTwo(blocks: [[Int]], freeSpaces: [Int: Int]) -> [[Int]] {
    var blocks = blocks
    var freeSpaces = freeSpaces
    let freeSpacesIndexes = freeSpaces.keys.sorted()
    
    for endIndex in stride(from: blocks.count - 1, through: 0, by: -1) {
        let endBlock = blocks[endIndex]
        guard !endBlock.contains(-1) else { continue }
        
        for freeSpaceIndex in freeSpacesIndexes {
            if freeSpaceIndex > endIndex {
                break
            }
            let availableSpace = freeSpaces[freeSpaceIndex] ?? 0
            if availableSpace >= endBlock.count {
                var freeSpaceBlock = blocks[freeSpaceIndex]
                var usedSlots = 0
                
                for (index, value) in freeSpaceBlock.enumerated() where value == -1 && usedSlots < endBlock.count {
                    freeSpaceBlock[index] = endBlock[usedSlots]
                    usedSlots += 1
                }
                blocks[freeSpaceIndex] = freeSpaceBlock
                
                freeSpaces[freeSpaceIndex] = availableSpace - endBlock.count
                
                blocks[endIndex] = Array(repeating: -1, count: endBlock.count)
                break
            }
        }
    }
    
    return blocks
}


if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    print("Starting...")
    
    var blocks = parseInputFile(filePath)
    
    if blocks.0.isEmpty {
        print("No blocks parsed from input file.")
    }
    let blocksPartOne = processBlocksPartOne(blocks: blocks.0)
    let checksumPartOne = calculateCheckSumPartOne(blocks: blocksPartOne)
    print("CheckSum Part One: \(checksumPartOne)")
    
    let blocksPartTwo = processBlocksPartTwo(blocks: blocks.0, freeSpaces: blocks.1)
    print(blocks)
    print(blocksPartTwo)
    let checksumPartTwo = calculateCheckSumPartTwo(blocks: blocksPartTwo)
    print("CheckSum Part Two: \(checksumPartTwo)")
} else {
    print("Input file not found.")
}
