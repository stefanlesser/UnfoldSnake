import Testing
@testable import Snake

@Test("Board initializes with a default size (16, 16)")
func testBoardInitializesWithDefaultSize() {
    let board = Board()
    #expect(board.size.x == 16)
    #expect(board.size.y == 16)
}

@Test("Initial snake placement is valid")
func testInitialSnakePlacementIsValid() {
    let board = Board()
    #expect(board.snake.body == [Position(x: 10, y: 10)])
    #expect(board.snake.direction == .right)
    #expect(board.snake.head == Position(x: 10, y: 10))
}

@Test("Food spawns at a random non-initial snake location")
func testFoodSpawnsAtRandomNonInitialSnakeLocation() {
    let board = Board()
    #expect(board.food.position != Position(x: 10, y: 10))
}

@Test("Random position generation")
func testRandomPositionGeneration() {
    let board = Board()
    let randomPosition = board.randomPosition
    #expect(randomPosition.x >= 0 && randomPosition.x < board.size.x)
    #expect(randomPosition.y >= 0 && randomPosition.y < board.size.y)
}

@Test(
    "Verify correct assignment of .snake, .food, or .empty based on position checks for all board states"
)
func testCorrectCellAssignment() throws {
    let board = Board()
    let snakePosition = board.snake.head
    let foodPosition = board.food.position
    let emptyPosition = Position(x: 5, y: 5)

    #expect(try board.query(position: snakePosition) == .snake, "Snake cell should be .snake")
    #expect(try board.query(position: foodPosition) == .food, "Food cell should be .food")
    #expect(try board.query(position: emptyPosition) == .empty, "Empty cell should be .empty")
}

@Test("Priority rule test in `query()` (case order)")
func testQueryPriority() throws {
    var board = Board()
    let snakePosition = board.snake.head
    board.food = Food(position: snakePosition)

    #expect(
        try board.query(position: snakePosition) == .food, "Food should take precedence over snake")
}

@Test("Out-of-bounds test within query()")
func testOutOfBoundsQuery() throws {
    let board = Board()
    let outOfBoundsPosition = Position(x: -1, y: -1)

    #expect(throws: SnakeError.outOfBounds) {
        try board.query(position: outOfBoundsPosition)
    }
}

@Test("`Board.update()` correctly throws `.outOfBounds` when `nextPosition` is out of bounds.")
func testUpdateThrowsOutOfBounds() throws {
    var board = Board()
    board.snake = Snake(body: [Position(x: 0, y: 0)], direction: .left)

    #expect(throws: SnakeError.outOfBounds) {
        try board.update()
    }
}

@Test("`Board.update()` correctly throws `.collision` when next move collides.")
func testUpdateThrowsCollision() throws {
    var board = Board()
    board.snake = Snake(
        body: [Position(x: 10, y: 10), Position(x: 11, y: 10), Position(x: 10, y: 10)],
        direction: .right)

    #expect(throws: SnakeError.collision) {
        try board.update()
    }
}

@Test("`Board.update()` correctly handles the `.food` case.")
func testUpdateHandlesFood() throws {
    var board = Board()
    let initialSnakeLength = board.snake.length
    let initialFoodPosition = board.food.position
    board.snake = Snake(body: [Position(x: initialFoodPosition.x - 1, y: initialFoodPosition.y)], direction: .right)

    try board.update()

    #expect(board.snake.length == initialSnakeLength + 1, "Snake should grow after eating food.")
    #expect(board.food.position != initialFoodPosition, "Food should respawn after being eaten.")
    #expect(board.isWithinBounds(position: board.food.position), "Food should respawn within board bounds.")
}

@Test("`Board.update()` correctly handles the `.food` case when the snake eats food and the new food position is not on the snake's body")
func testUpdateHandlesFoodNewFoodPositionNotOnSnakeBody() throws {
    var board = Board()
    let initialFoodPosition = Position(x: 1, y: 0)
    board.food = Food(position: initialFoodPosition)
    board.snake = Snake(body: [Position(x: 0, y: 0)], direction: .right)

    try board.update()

    #expect(board.food.position != board.snake.head, "Food position shouldn't be at snake's head")
}

@Test("Board resets after collision")
func testBoardResetAfterCollision() throws {
    var board = Board()
    board.snake = Snake(
        body: [Position(x: 10, y: 10), Position(x: 11, y: 10), Position(x: 10, y: 10)],
        direction: .right)

    try? board.update()

    #expect(
        board.snake.body == [Position(x: 10, y: 10)], "Snake should be reset to initial position")
    #expect(board.snake.direction == .right, "Snake should be reset to initial direction")
    #expect(board.size.x == 16, "Board size should remain the same")
    #expect(board.size.y == 16, "Board size should remain the same")
    #expect(
        board.isWithinBounds(position: board.food.position),
        "Food must be spawned inside board bounds after reset.")
}
