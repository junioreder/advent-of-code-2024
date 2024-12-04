import Foundation

struct Table {
    var leftColumn: [Int] = []
    var rightColumn: [Int] = []
    
    mutating func add(leftValue: Int, rightValue: Int) {
        leftColumn.append(leftValue)
        rightColumn.append(rightValue)
        
        leftColumn = leftColumn.sorted()
        rightColumn = rightColumn.sorted()
    }
    
    func getTotalDistance() -> Int {
        var totalDistance = 0
        
        for i in 0..<leftColumn.count {
            let leftValue = leftColumn[i]
            let rightValue = rightColumn[i]
            
            totalDistance += abs(leftValue - rightValue)
        }
        
        return totalDistance
    }
    
    func countInRightColumn(_ value: Int) -> Int {
        return rightColumn.filter({$0 == value}).count
    }
    
    func getTotalSimilarity() -> Int {
        var totalSimilarity = 0
        
        for i in 0..<leftColumn.count {
            let leftValue = leftColumn[i]
            
            totalSimilarity += (leftValue * countInRightColumn(leftValue))
        }
        
        return totalSimilarity
    }
}

func getTable(inputText: String) -> Table {
    let lines = inputText.split(separator: "\n")
    
    var table = Table()
    
    for line in lines {
        let values = line.split(separator: "   ")
        let leftValue = Int(values.first ?? "0") ?? 0
        let rightValue = Int(values.last ?? "0") ?? 0
        
        table.add(leftValue: leftValue, rightValue: rightValue)
    }
    
    return table
}


if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let table = getTable(inputText: inputText)
        
        let totalDistance = table.getTotalDistance()
        let totalSimilarity = table.getTotalSimilarity()
        
        print(totalDistance)
        print(totalSimilarity)
    } catch {
        print("Error reading file: \(error)")
    }
} else {
    print("File not found")
}
