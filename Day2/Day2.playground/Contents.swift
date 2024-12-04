import Foundation

struct Line {
    var values: [Int]
    
    init(text: String) {
        values = text
            .split(separator: " ")
            .compactMap {
                Int($0)
            }
    }
    
    func isValid() -> Bool {
        if isValid(values: values) {
            return true
        }
        
        for i in 0..<values.count {
            var values = values
            values.remove(at: i)
            if isValid(values: values) {
                return true
            }
        }
        
        return false
    }
    
    private func isValid(values: [Int]) -> Bool {
        guard values.count > 1, values[0] != values[1] else {
            return false
        }
        
        var isAsc = values[1] > values[0]
        
        var comparingValue = values[0]
        
        for i in 1..<values.count {
            var currentValue = values[i]
            
            if currentValue == comparingValue {
                return false
            }
            
            if abs(comparingValue - currentValue) > 3 {
                return false
            }
            
            if isAsc && currentValue < comparingValue {
                return false
            } else if !isAsc && currentValue > comparingValue {
                return false
            }
            
            comparingValue = currentValue
        }
        
        return true
    }
}

struct Table {
    var validCount: Int = 0
    
    init(inputText: String) {
        var lines = inputText.split(separator: "\n")
        
        for line in lines {
            let line = Line(text: String(line))
            
            if line.isValid() {
                validCount += 1
            }
        }
    }
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let table = Table(inputText: inputText)
        
        print(table.validCount)
        
    } catch {
        print("Error reading file: \(error)")
    }
} else {
    print("File not found")
}
