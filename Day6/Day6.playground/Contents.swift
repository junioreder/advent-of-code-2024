import Foundation

enum WalkResult {
    case exit(visited: Set<String>, visitedUnique: Set<String>)
    case loop(visited: Set<String>, visitedUnique: Set<String>)
    case missingInitialPosition
}

enum GuardDirection: Int {
    case up, right, down, left

    var next: GuardDirection {
        GuardDirection(rawValue: (self.rawValue + 1) % 4)!
    }

    var offset: (dx: Int, dy: Int) {
        switch self {
        case .up: return (0, -1)
        case .left: return (-1, 0)
        case .right: return (1, 0)
        case .down: return (0, 1)
        }
    }
    
    var value: Character {
        switch self {
        case .up: return "^"
        case .left: return "<"
        case .right: return ">"
        case .down: return "v"
        }
    }
}

enum Position: Character, CaseIterable {
    case empty = "."
    case obstacle = "#"
    case guardianUp = "^"
    case guardianLeft = "<"
    case guardianRight = ">"
    case guardianDown = "v"

    var isObstacle: Bool { self == .obstacle }
    var isGuardian: Bool { self.rawValue.isLetter }
    var direction: GuardDirection? {
        switch self {
        case .guardianUp: return .up
        case .guardianLeft: return .left
        case .guardianRight: return .right
        case .guardianDown: return .down
        default: return nil
        }
    }
}

struct Board {
    var grid: [[Position]]
    var initialGuard: (position: (x: Int, y: Int), direction: GuardDirection)?
    
    init(input: String) throws {
        grid = input.split(separator: "\n").map { line in
            line.map { Position(rawValue: $0) ?? .empty }
        }

        for (y, row) in grid.enumerated() {
            for (x, pos) in row.enumerated() {
                if let dir = pos.direction {
                    guard initialGuard == nil else { throw NSError(domain: "Duplicate guardian", code: 1) }
                    initialGuard = ((x, y), dir)
                }
            }
        }
    }

    func walk(adittionalObstacle: (x: Int, y: Int)? = nil) -> WalkResult {
        guard var (x, y, dir) = initialGuard.map({ ($0.position.x, $0.position.y, $0.direction) }) else {
            return .missingInitialPosition
        }
        
        var visited: Set<String> = []
        var visitedUnique: Set<String> = []

        while true {
            let visitedUniqueKey = "\(x)-\(y)"
            visitedUnique.insert(visitedUniqueKey)
            
            let key = "\(x)-\(y)-\(dir.rawValue)"
            if visited.count > 1 && visited.contains(key) {
                return .loop(visited: visited, visitedUnique: visitedUnique)
            }
            visited.insert(key)
            
            if (dir == .right && x == grid[y].count - 1) ||
                (dir == .left && x == 0) ||
                (dir == .up && y == 0) ||
                (dir == .down && y == grid.count - 1){
                break
            }
            
            let (dx, dy) = dir.offset
            let nx = x + dx, ny = y + dy

            if let adittionalObstacle, adittionalObstacle.x == nx && adittionalObstacle.y == ny {
                dir = dir.next
                continue
            }
            
            if ny < 0 || ny >= grid.count || nx < 0 || nx >= grid[ny].count || grid[ny][nx].isObstacle {
                dir = dir.next
                continue
            }

            x = nx
            y = ny
        }
        return .exit(visited: visited, visitedUnique: visitedUnique)
    }
}

actor Counter {
    private var value: Int = 0

    func increment() {
        value += 1
        print(value)
    }

    func getValue() -> Int {
        value
    }
}

func testObstaclesToCreateLoop(board: Board, visitedUnique: Set<String>) -> Int {
    guard let initialGuardPosition = board.initialGuard else {
        return 0
    }
    
    let counter = Counter()
    let dispatchGroup = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 10)

    for walkedPosition in visitedUnique {
        let splitPosition = walkedPosition.split(separator: "-")
        guard splitPosition.count == 2,
              let x = Int(splitPosition[0]),
              let y = Int(splitPosition[1]) else {
            continue
        }
        
        guard x != initialGuardPosition.position.x || y != initialGuardPosition.position.y else {
            continue
        }
        
        dispatchGroup.enter()
        semaphore.wait()
        DispatchQueue.global().async {
            defer {
                semaphore.signal()
                dispatchGroup.leave()
            }
            
            let walkResult = board.walk(adittionalObstacle: (x: x, y: y))
            
            if case .loop = walkResult {
                Task {
                    await counter.increment()
                }
            }
        }
    }
    
    dispatchGroup.wait()
    
    var result: Int = 0
    let resultSemaphore = DispatchSemaphore(value: 0)
    Task {
        result = await counter.getValue()
        resultSemaphore.signal()
    }
    resultSemaphore.wait()
    
    return result
}

if let filePath = Bundle.main.path(forResource: "input", ofType: "txt") {
    do {
        print("Starting...")
        let inputText = try String(contentsOfFile: filePath, encoding: .utf8)
        var board = try Board(input: inputText)
        let result = board.walk()
        
        if case .exit(let visited, let visitedUnique) = result {
            print("Count: \(visitedUnique.count)")
            
            let numberOfObstacles = testObstaclesToCreateLoop(board: board, visitedUnique: visitedUnique)
            
            print("NumberOfObstacles: \(numberOfObstacles)")
        }
    } catch {
        print("Error: \(error)")
    }
} else {
    print("Input file not found.")
}
