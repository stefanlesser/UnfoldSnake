import Testing

@testable import Snake

@Test("Vector addition works correctly")
func testVectorAddition() {
    let vector1 = Vector(x: 1, y: 2)
    let vector2 = Vector(x: 3, y: 4)
    let result = vector1 + vector2
    #expect(result == Vector(x: 4, y: 6))
}

@Test("Vector addition with zero vector")
func testVectorAdditionWithZero() {
    let vector = Vector(x: 5, y: 7)
    let zero = Vector(x: 0, y: 0)
    let result = vector + zero
    #expect(result == Vector(x: 5, y: 7))
}
