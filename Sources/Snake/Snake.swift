// A VECTOR represents a 2D position, velocity, or size.
public struct Vector: Equatable, Hashable, Sendable {
    public var x: Int
    public var y: Int

    static func + (_ left: Vector, _ right: Vector) -> Vector {
        Vector(x: left.x + right.x, y: left.y + right.y)
    }
}

// A POSITION represents a point coordinate in 2D space.
public typealias Position = Vector

// A VELOCITY represents a vector of movement in 2D space.
typealias Velocity = Vector

// A SIZE represents a bounded area in 2D space.
typealias Size = Vector

// A DIRECTION represents where the SNAKE is moving.
public enum Direction: CaseIterable, Equatable, Sendable {
    // There are four possible DIRECTIONS.
    case up, right, down, left

    // Each DIRECTION can be converted into a VELOCITY vector.
    var velocity: Velocity {
        switch self {
        case .up:
            return Velocity(x: 0, y: 1)
        case .right:
            return Velocity(x: 1, y: 0)
        case .down:
            return Velocity(x: 0, y: -1)
        case .left:
            return Velocity(x: -1, y: 0)
        }
    }
}

// The SNAKE moves on the BOARD.
public struct Snake {
    // The SNAKE's body consists of an array of POSITION coordinates in space.
    public var body: [Position]

    // The SNAKE is headed into a DIRECTION.
    public var direction: Direction

    // The SNAKE has a LENGTH.
    var length: Int {
        body.count
    }

    // The SNAKE's head is the first POSITION of its body.
    var head: Position {
        body.first!
    }

    // The SNAKE head's nextPosition is its current head's position + its velocity.
    var nextPosition: Position {
        head + direction.velocity
    }

    // The SNAKE moves by inserting at the HEAD in DIRECTION and removing its TAIL.
    mutating func move() {
        body.insert(nextPosition, at: 0)
        body.removeLast()
    }

    // The SNAKE grows by inserting at the HEAD without removing its TAIL.
    mutating func grow() {
        body.insert(nextPosition, at: 0)
    }
}

// The SNAKE eats FOOD it finds on the BOARD.
public struct Food {
    // FOOD has a position.
    public var position: Position
}

// A CELL represents an indivisible location on the BOARD addressable by a POSITION coordinate.
enum Cell {
    case snake, food, empty
}

//
public enum SnakeError: Error {
    case outOfBounds, collision
}

// The BOARD represents a 2D grid of CELLs.
public struct Board {
    // The BOARD has a size.
    var size: Size

    // There's a SNAKE on the BOARD.
    public var snake: Snake

    // There's FOOD on the BOARD.
    public var food: Food

    // Pick a random POSITION on the BOARD.
    var randomPosition: Position {
        Self.randomPosition(in: size)
    }

    // Generate a random position for a given size
    static func randomPosition(in size: Size) -> Position {
        let x = Int.random(in: 0..<size.x)
        let y = Int.random(in: 0..<size.y)
        return Position(x: x, y: y)
    }

    public init() {
        // The BOARD size is (16, 16).
        size = Size(x: 16, y: 16)

        // The SNAKE spawns with length 1 at POSITION (10, 10) facing in DIRECTION right.
        snake = Snake(body: [Position(x: 10, y: 10)], direction: .right)

        // FOOD spawns at a random POSITION.
        food = Food(position: Board.randomPosition(in: size))
    }

    // A POSITION is either on the BOARD or not.
    func isWithinBounds(position: Position) -> Bool {
        (0..<size.x).contains(position.x) && (0..<size.y).contains(position.y)
    }

    // At a POSITION on the BOARD is either the SNAKE, FOOD, or empty space.
    func query(position: Position) throws(SnakeError) -> Cell {
        guard isWithinBounds(position: position) else {
            throw SnakeError.outOfBounds
        }
        if food.position == position {
            return .food
        } else if snake.body.contains(position) {
            return .snake
        } else {
            return .empty
        }
    }

    // The BOARD updates as the GAME progresses.
    public mutating func update() throws(SnakeError) {
        // The SNAKE dies if it goes out of bounds.
        guard isWithinBounds(position: snake.nextPosition) else {
            throw SnakeError.outOfBounds
        }

        // Check POSITION the SNAKE is about to move to.
        switch try query(position: snake.nextPosition) {
        case .snake:
            // The SNAKE dies if it collides with itself.
            self = Board() // Reset the board
            throw SnakeError.collision
        case .food:
            // Eating FOOD makes the SNAKE grow.
            snake.grow()

            // FOOD respawns at a random empty POSITION.
            var position: Position
            repeat {
                position = randomPosition
            } while try query(position: position) != .empty
            food = Food(position: position)
        case .empty:
            snake.move()
        }
    }
}
