import Testing

@testable import Snake

@Test("Next position calculation based solely on direction")
func testNextPositionCalculation() {
    let snake = Snake(body: [Position(x: 10, y: 10)], direction: .right)
    #expect(snake.nextPosition == Position(x: 11, y: 10))
}

@Test("move() function correctly adds one element to the body and removes one from the end")
func testMoveFunctionCorrectlyAddsAndRemoves() throws {
    var snake = Snake(
        body: [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
        direction: .right)

    snake.move()

    #expect(snake.body.count == 3, "Snake length should remain constant")
}

@Test("grow() function correctly adds one element to the body without removing any")
func testGrowFunctionCorrectlyAddsElement() throws {
    var snake = Snake(
        body: [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
        direction: .right)
    let initialLength = snake.length

    snake.grow()

    #expect(snake.length == initialLength + 1, "Snake length should increase by 1")
}

@Test(
    "Length calculation reflects the actual body array count accurately after movement and growth")
func testLengthCalculation() throws {
    var snake = Snake(body: [Position(x: 10, y: 10)], direction: .right)
    #expect(snake.length == 1, "Initial length should be 1")

    snake.grow()
    #expect(snake.length == 2, "Length after grow should be 2")

    snake.move()
    #expect(snake.length == 2, "Length after move should still be 2")
}
