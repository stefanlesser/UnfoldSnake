import Testing
@testable import Snake

@Test("Out-of-bounds collision logic")
func testOutOfBoundsCollision() throws {
    var board = Board()
    board.snake = Snake(body: [Position(x: 0, y: 0)], direction: .right)

    // Test x = -1
    board.snake.body[0] = Position(x: 0, y: 0)
    board.snake.direction = .left
    #expect(throws: SnakeError.outOfBounds) {
        try board.update()
    }

    // Test y = -1
    board.snake.body[0] = Position(x: 0, y: 0)
    board.snake.direction = .down
    #expect(throws: SnakeError.outOfBounds) {
        try board.update()
    }

    // Test x = size.x
    board.snake.body[0] = Position(x: 15, y: 0)
    board.snake.direction = .right
   #expect(throws: SnakeError.outOfBounds) {
        try board.update()
    }

    // Test y = size.y
    board.snake.body[0] = Position(x: 0, y: 15)
    board.snake.direction = .up
    #expect(throws: SnakeError.outOfBounds) {
        try board.update()
    }
}

@Test("Self-collision logic")
func testSelfCollision() throws {
    var board = Board()
    board.snake = Snake(body: [Position(x: 10, y: 10), Position(x: 11, y: 10), Position(x: 12, y: 10)], direction: .left)
    board.snake.body[0] = Position(x: 10, y: 10)
    board.snake.direction = .right

   #expect(throws: SnakeError.collision) {
        try board.update()
    }
}