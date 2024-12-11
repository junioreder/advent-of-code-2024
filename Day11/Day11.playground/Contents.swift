import Foundation

class Stone {
    private var memo: [Int: [Int]] = [:]
    
    var initialNumberCounts: [Int: Int]
    
    init(_ filePath: String) {
        do {
            let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
            let numbers = inputText.trim().split(separator: " ").compactMap { Int($0) }
            self.initialNumberCounts = numbers.reduce(into: [:]) { counts, number in
                counts[number, default: 0] += 1
            }
        } catch {
            print("Error reading input file: \(error)")
            self.initialNumberCounts = [:]
        }
    }
    
    func getNumberList(with number: Int) -> [Int] {
        if let cached = memo[number] {
            return cached
        }
        
        let result: [Int]
        if number == 0 {
            result = [1]
        } else {
            let numberString = String(number)
            let count = numberString.count
            let midIndex = count / 2
            
            if count % 2 == 0 {
                let firstPart = Int(numberString.prefix(midIndex))!
                let secondPart = Int(numberString.suffix(midIndex))!
                result = [firstPart, secondPart]
            } else {
                result = [number * 2024]
            }
        }
        
        memo[number] = result
        return result
    }
    
    func getNumberCounts(numberCounts: [Int: Int], currentBlinks: Int, blinks: Int) -> [Int: Int] {
        var currentCounts = numberCounts
        
        for _ in (currentBlinks+1)...blinks {
            var newCounts: [Int: Int] = [:]
            
            for (number, count) in currentCounts {
                let results = getNumberList(with: number)
                for result in results {
                    newCounts[result, default: 0] += count
                }
            }
            
            currentCounts = newCounts
        }
        
        return currentCounts
    }
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    print("Starting...")
    
    var stone = Stone(filePath)
    
    let finalCountsPartOne = stone.getNumberCounts(numberCounts: stone.initialNumberCounts, currentBlinks: 0, blinks: 25)
    let finalCountsPartTwo = stone.getNumberCounts(numberCounts: finalCountsPartOne, currentBlinks: 25, blinks: 75)
    
    print("Total Part One:: \(finalCountsPartOne.values.reduce(0, +))")
    print("Total Part Two:: \(finalCountsPartTwo.values.reduce(0, +))")
    
} else {
    print("Input file not found.")
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
