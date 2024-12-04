import Foundation


func getCalculatedValue(text: String) -> Int {
    let pattern = "mul\\(\\d*\\,\\d*\\)"
    let regex = try! NSRegularExpression(pattern: pattern)

    let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

    let numbers = matches.map { (text as NSString).substring(with: $0.range) }

    var sum = 0
    for number in numbers {
        let value = number
            .replacingOccurrences(of: "mul(", with: "")
            .replacingOccurrences(of: ")", with: "")
        let numbers = value.split(separator: ",")
        let leftNumber = Int(numbers.first ?? "0") ?? 0
        let rightNumber = Int(numbers.last ?? "0") ?? 0
        let result = leftNumber * rightNumber
        
        sum += result
    }
    
    return sum
}

func removeDont(inputText: String) -> String {
    let pattern = "don't\\(\\)[\\s\\S]*?(do\\(\\)|$)"
    
    if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
        let range = NSRange(inputText.startIndex..<inputText.endIndex, in: inputText)
        return regex.stringByReplacingMatches(in: inputText, options: [], range: range, withTemplate: "")
    } else {
        return inputText
    }
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let textWithouDont = removeDont(inputText: inputText)
        
        let calculatedValue = getCalculatedValue(text: textWithouDont)
        
        print(calculatedValue)
    } catch {
        print("Error reading file: \(error)")
    }
} else {
    print("File not found")
}
