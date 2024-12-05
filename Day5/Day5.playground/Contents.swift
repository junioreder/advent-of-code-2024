import Foundation

struct Rules {
    var subsequentRules: [Int: [Int]] = [:]
    var precendentRules: [Int: [Int]] = [:]
    
    init(input: String) {
        var ruleList = input.split(separator: "\n")
        
        for rule in ruleList {
            var numbers = rule.split(separator: "|")
            let firstNumber = Int(numbers[0]) ?? 0
            let secondNumber = Int(numbers[1]) ?? 0
            if subsequentRules[secondNumber] == nil {
                subsequentRules[secondNumber] = [firstNumber]
            } else {
                subsequentRules[secondNumber]?.append(firstNumber)
            }
            
            if precendentRules[firstNumber] == nil {
                precendentRules[firstNumber] = [secondNumber]
            } else {
                precendentRules[firstNumber]?.append(secondNumber)
            }
        }
    }
    
    func geMiddleElementSum(input: String) -> (Int, Int) {
        let lineList = input.split(separator: "\n")
        
        var correctElementsSum = 0
        var fixedIncorrectElementsSum = 0
        
        var lineNumber = 1
        for line in lineList {
            let numberList = line
                .split(separator: ",")
                .compactMap {
                    Int($0)
                }
            
            if isValid(numberList: numberList), let middleElement = numberList.middleElement() {
                correctElementsSum += middleElement
            } else {
                let newNumberList = makeValid(numberList: numberList)
                fixedIncorrectElementsSum += newNumberList.middleElement() ?? 0
            }
            lineNumber += 1
        }
        
        return (correctElementsSum, fixedIncorrectElementsSum)
    }
    
    private func makeValid(numberList: [Int]) -> [Int] {
        var newNumberList: [Int] = []

        for number in numberList {
            newNumberList = appendValid(number: number, in: newNumberList)
        }
        
        return newNumberList
    }
    
    private func appendValid(number: Int, in numberList: [Int]) -> [Int] {
        var newNumberList = numberList
        
        if newNumberList.isEmpty {
            newNumberList.append(number)
        } else {
            if let precendents = precendentRules[number] {
                for i in 0..<newNumberList.count {
                    var currentNumber = newNumberList[i]
                    if precendents.contains(currentNumber) {
                        newNumberList.insert(number, at: i)
                        break
                    }
                }    
            }
            
            if !newNumberList.contains(number) {
                newNumberList.append(number)
            } else if !isValid(numberList: newNumberList) {
                newNumberList = makeValid(numberList: newNumberList)
            }
        }
        
        return newNumberList
    }
    
    private func isValid(numberList: [Int]) -> Bool {
        
        for i in 0..<numberList.count {
            let previousList = numberList.suffix(i)
            let current = numberList[i]
            let nextList = numberList.suffix(from: i+1)
            
            if let subsequents = subsequentRules[current], previousList.count > 0 {
                for next in nextList {
                    if subsequents.contains(next) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}

extension Array {
    func middleElement() -> Element? {
        guard !isEmpty else { return nil }
        return self[count / 2]
    }
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let splittedInputText = inputText.split(separator: "\n\n")
        
        let inputRules = String(splittedInputText[0])
        let printedOrders = String(splittedInputText[1])
        let rules = Rules(input: inputRules)
        let middleElementSum = rules.geMiddleElementSum(input: printedOrders)
        
        print("Sum valid middle elements: \(middleElementSum.0)")
        print("Sum fixed invalid middle elements: \(middleElementSum.1)")
        print("Sum all middle elements after fix: \(middleElementSum.0 + middleElementSum.1)")
        
    } catch {
        print("Error reading file: \(error)")
    }
} else {
    print("File not found")
}
