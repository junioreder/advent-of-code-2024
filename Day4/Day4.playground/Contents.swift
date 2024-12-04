import Foundation

struct Line {
    private(set) var value: [String] = []
    
    mutating func append(_ value: String) {
        self.value.append(value)
    }
}

struct Table {
    var lines: [Line] = []
       
    init(inputText: String) {
        let inputLines = inputText.split(separator: "\n")
        
        for inputLine in inputLines {
            var line = Line()
            
            for value in inputLine {
                line.append("\(value)")
            }
            self.lines.append(line)
        }
    }
    
    func getCount(search: String) -> Int {
        var count = 0
        
        for x in 0..<lines.count {
            let line = lines[x]
            
            for y in 0..<line.value.count {
                if isHorizontal(search: search, x: x, y: y) {
                    count += 1
                }
                if isHorizontalReverse(search: search, x: x, y: y) {
                    count += 1
                }
                if isVertical(search: search, x: x, y: y) {
                    count += 1
                }
                if isVerticalReverse(search: search, x: x, y: y) {
                    count += 1
                }
                if isDiagonalUpLeft(search: search, x: x, y: y) {
                    count += 1
                }
                if isDiagonalUpRight(search: search, x: x, y: y) {
                    count += 1
                }
                if isDiagonalDownLeft(search: search, x: x, y: y) {
                    count += 1
                }
                if isDiagonalDownRight(search: search, x: x, y: y) {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func getMASInXFormat() -> Int {
        var count = 0
        
        for x in 0..<lines.count {
            let line = lines[x]
            
            for y in 0..<line.value.count {
                if x > 0 && y > 0 &&
                    x < (lines.count - 1) &&
                    y < (line.value.count - 1) {
                    let current = line.value[y]
                    
                    if current == "A" {
                        var topLeft = lines[x-1].value[y-1]
                        var bottomRight = lines[x+1].value[y+1]
                        var topRight = lines[x-1].value[y+1]
                        var bottomLeft = lines[x+1].value[y-1]
                        if isXValid(cornerOne: topLeft, cornerTwo: bottomRight) && isXValid(cornerOne: topRight, cornerTwo: bottomLeft) {
                            count += 1
                        }
                    }
                }
            }
        }
        
        return count
    }
    
    func isXValid(cornerOne: String, cornerTwo: String) -> Bool {
        return (cornerOne == "M" && cornerTwo == "S") || (cornerOne == "S" && cornerTwo == "M")
    }
    
    func isHorizontal(search: String, x: Int, y: Int) -> Bool {
        let columnCount = lines[x].value.count
         
        guard y + search.count <= columnCount else {
            return false
        }
        
        for i in 0..<search.count {
            let current = search.string(at: i)
            if lines[x].value[y+i] != current {
                return false
            }
        }
        
        return true
    }
    
    func isHorizontalReverse(search: String, x: Int, y: Int) -> Bool {
        
        guard y + 1 - search.count >= 0 else {
            return false
        }
        
        var value = ""
        for i in 0..<search.count {
            let current = search.string(at: i)
            
            if lines[x].value[y-i] != current {
                return false
            }
        }
        
        return true
    }
    
    func isVertical(search: String, x: Int, y: Int) -> Bool {
        let lineCount = lines.count
         
        guard x + search.count <= lineCount else {
            return false
        }
        
        for i in 0..<search.count {
            let current = search.string(at: i)
            if lines[x+i].value[y] != current {
                return false
            }
        }
        
        return true
    }
    
    func isVerticalReverse(search: String, x: Int, y: Int) -> Bool {
        
        guard x + 1 - search.count >= 0 else {
            return false
        }
        
        var value = ""
        for i in 0..<search.count {
            let current = search.string(at: i)
            
            if lines[x-i].value[y] != current {
                return false
            }
        }
        
        return true
    }
    
    func isDiagonalDownRight(search: String, x: Int, y: Int) -> Bool {
        
        let columnCount = lines[x].value.count
        let lineCount = lines.count
        
        guard y + search.count <= columnCount &&
                x + search.count <= lineCount else {
            return false
        }
        
        for i in 0..<search.count {
            let current = search.string(at: i)
            if lines[x+i].value[y+i] != current {
                return false
            }
        }
        
        return true
    }
    
    func isDiagonalDownLeft(search: String, x: Int, y: Int) -> Bool {
        let lineCount = lines.count
                
        guard x + search.count <= lineCount &&
                y + 1 - search.count >= 0 else {
            return false
        }
        
        for i in 0..<search.count {
            let current = search.string(at: i)

            if lines[x+i].value[y-i] != current {
                return false
            }
        }
        
        return true
    }
    
    func isDiagonalUpRight(search: String, x: Int, y: Int) -> Bool {
        let columnCount = lines[x].value.count
        
        guard x + 1 - search.count >= 0 &&
                y + search.count <= columnCount else {
            return false
        }
        
        for i in 0..<search.count {
            let current = search.string(at: i)
            if lines[x-i].value[y+i] != current {
                return false
            }
        }
        
        return true
    }
    
    func isDiagonalUpLeft(search: String, x: Int, y: Int) -> Bool {
        
        guard x + 1 - search.count >= 0 &&
                y + 1 - search.count >= 0 else {
            return false
        }
        
        var value = ""
        for i in 0..<search.count {
            let current = search.string(at: i)
            
            if lines[x-i].value[y-i] != current {
                return false
            }
        }
        
        return true
    }
}


if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let table = Table(inputText: inputText)
        
        let countXMAS = table.getCount(search: "XMAS")
        let countMASInXFormat = table.getMASInXFormat()
        
        print("countXMAS: \(countXMAS)")
        print("countMASInXFormat: \(countMASInXFormat)")
    } catch {
        print("Error reading file: \(error)")
    }
} else {
    print("File not found")
}

extension String.SubSequence {
    func string(at position: Int) -> String {
        guard position >= 0 && position < self.count else { return "" }
        let index = self.index(self.startIndex, offsetBy: position)
        return String(self[index])
    }
}

extension String {
    func string(at position: Int) -> String {
        guard position >= 0 && position < self.count else { return "" }
        let index = self.index(self.startIndex, offsetBy: position)
        return String(self[index])
    }
}
