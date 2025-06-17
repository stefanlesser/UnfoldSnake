import Testing

@testable import Snake

@Test("Vector addition works correctly")
func testVectorAddition() {
    let vector1 = Vector(x: 1, y: 2)
    let vector2 = Vector(x: 3, y: 4)
    #expect(vector1 + vector2 == Vector(x: 4, y: 6))
}

@Test("Vector addition with zero vector")
func testVectorAdditionWithZero() {
    let vector = Vector(x: 5, y: 7)
    let zero = Vector(x: 0, y: 0)
    #expect(vector + zero == Vector(x: 5, y: 7))
}

@Test("Directions work correctly", arguments: zip(
    Direction.allCases,
    [Position(x: 5, y: 8), Position(x: 6, y: 7), Position(x: 5, y: 6), Position(x: 4, y: 7)]
))
func testDirections(_ direction: Direction, _ expected: Position) {
    let vector1 = Vector(x: 5, y: 7)
    let vector2 = direction.velocity
    #expect(vector1 + vector2 == expected)
}
