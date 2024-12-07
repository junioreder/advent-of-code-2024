import Foundation

func generateBinaryNumbers(forLength length: Int) -> [Int] {
    if length <= 0 { return [] }
    return Array(0..<(1 << length))
}

func generateTernaryNumbers(forLength length: Int) -> [Int] {
    if length <= 0 { return [] }
    
    let totalCombinations = Int(pow(3.0, Double(length)))
    var result: [Int] = []
    
    for number in 0..<totalCombinations {
        var currentNumber = number
        var containsTwo = false
        
        for _ in 0..<length {
            if currentNumber % 3 == 2 {
                containsTwo = true
                break
            }
            currentNumber /= 3
        }
        
        if containsTwo {
            result.append(number)
        }
    }
    
    return result
}

func digitsOfTernary(number: Int, length: Int) -> [Int] {
    var digits: [Int] = []
    var currentNumber = number
    
    for _ in 0..<length {
        let digit = currentNumber % 3
        digits.insert(digit, at: 0)
        currentNumber /= 3
    }
    
    return digits
}

func generateBinaryNumbersRecursively(currentResult: Int, index: Int, values: [Int], expectedResult: Int) -> Bool {
    if index == values.count - 1 {
        return currentResult == expectedResult
    }

    let nextValue = values[index + 1]
    
    if currentResult * nextValue <= expectedResult {
        if generateBinaryNumbersRecursively(currentResult: currentResult * nextValue, index: index + 1, values: values, expectedResult: expectedResult) {
            return true
        }
    }

    if currentResult + nextValue <= expectedResult {
        if generateBinaryNumbersRecursively(currentResult: currentResult + nextValue, index: index + 1, values: values, expectedResult: expectedResult) {
            return true
        }
    }
    
    return false
}

func calculateResult(
    _ values: [Int],
    _ expectedResult: Int,
    _ index: Int,
    _ currentResult: Int
) -> Bool {
    if index == values.count {
        return currentResult == expectedResult
    }
    
    let nextValue = values[index]
    
    // Tenta multiplicação
    if currentResult * nextValue <= expectedResult {
        if calculateResult(values, expectedResult, index + 1, currentResult * nextValue) {
            return true
        }
    }
    
    // Tenta adição
    if currentResult + nextValue <= expectedResult {
        if calculateResult(values, expectedResult, index + 1, currentResult + nextValue) {
            return true
        }
    }
    
    // Tenta concatenação
    if let concatenatedValue = Int("\(currentResult)\(nextValue)"),
       concatenatedValue <= expectedResult {
        if calculateResult(values, expectedResult, index + 1, concatenatedValue) {
            return true
        }
    }
    
    return false
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        print("Starting...")
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let equations = inputText.split(separator: "\n")
        
        var incorrectEquationList: [String] = []
        
        var currentSumPartOne = 0
        
        for equation in equations {
            let splittedEquation = equation.split(separator: ":")
            let expectedResult = Int(splittedEquation[0])!
            
            let values: [Int] = splittedEquation[1]
                .split(separator: " ")
                .compactMap {
                    Int($0)
                }
            
            if generateBinaryNumbersRecursively(currentResult: values[0], index: 0, values: values, expectedResult: expectedResult) {
                currentSumPartOne += expectedResult
            } else {
                incorrectEquationList.append(String(equation))
            }
        }
        
        print("Sum PartOne: \(currentSumPartOne)")
        
        var currentSumPartTwo = 0
        
        for equation in incorrectEquationList {
            let splittedEquation = equation.split(separator: ":")
            let expectedResult = Int(splittedEquation[0])!
            
            let values: [Int] = splittedEquation[1]
                .split(separator: " ")
                .compactMap {
                    Int($0)
                }
            
            if calculateResult(values, expectedResult, 1, values[0]) {
                currentSumPartTwo += expectedResult
            }
            
            print("Equation: \(equation)")
        }
        
        print("Sum PartTwo: \(currentSumPartTwo)")
        print("Total Sum: \(currentSumPartOne+currentSumPartTwo)")
    } catch {
        print("Error: \(error)")
    }
} else {
    print("Input file not found.")
}
