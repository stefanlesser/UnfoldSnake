import Testing
@testable import Snake

@Test("Verify initial random position is valid for all board sizes tested")
func testInitialRandomPositionIsValid() {
    let board = Board()
    #expect(board.isWithinBounds(position: board.food.position), "Initial food position should be within board bounds")
}

@Test("Respawn logic after eating avoids placing food on snake cells")
func testRespawnLogicAvoidsSnakeCells() throws {
    var board = Board()
    // Place snake at (0,0)
    board.snake = Snake(body: [Position(x: 0, y: 0)], direction: .right)

    // Place food at (0,0) - it will respawn on update
    board.food = Food(position: Position(x:0, y:0))

    try board.update()

    #expect(!board.snake.body.contains(board.food.position), "Food should not respawn on snake cell")
}
