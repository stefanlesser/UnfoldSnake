import Observation
import SwiftUI
import Snake

@MainActor
@Observable
class GameModel {
    var board: Board = Board()

    private var timer: Timer?

    init() {
        // Set up timer that updates model regularly
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateModel()
            }
        }
    }

    private func updateModel() {
        do {
            try board.update()
        } catch {
            switch error {
            case .outOfBounds: print("Out of Bounds!")
            case .collision: print("Collision!")
            }
        }
    }

    func changeSnakeDirection(_ direction: Direction) {
        var board = self.board
        board.snake.direction = direction
        self.board = board
    }

    deinit {
        MainActor.assumeIsolated {
            timer?.invalidate()
            timer = nil
        }
    }
}

package struct BoardView: View {
    @State private var model = GameModel()
    @FocusState private var isFocused: Bool

    private var snakePositions: [Position] {
        model.board.snake.body
    }

    private var foodPosition: Position {
        model.board.food.position
    }

    init(model: GameModel = GameModel(), isFocused: Bool = false) {
        self.model = model
        self.isFocused = isFocused
    }

    package init() {
    }

    package var body: some View {
        Group {
            ZStack {
                // Render snake body
                ForEach(snakePositions, id: \.self) { position in
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                        .position(
                            x: CGFloat(position.x) * 20,
                            y: CGFloat(position.y) * 20
                        )
                }

                // Render food
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .position(
                        x: CGFloat(foodPosition.x) * 20,
                        y: CGFloat(foodPosition.y) * 20
                    )
            }
            .frame(width: 320, height: 320)
            .border(.black)
        }
        .focusable()
        .focused($isFocused)
        .onAppear { isFocused = true }
        .onKeyPress { keyPress in
            switch keyPress.characters {
            case "w": model.changeSnakeDirection(.up)
            case "s": model.changeSnakeDirection(.down)
            case "a": model.changeSnakeDirection(.left)
            case "d": model.changeSnakeDirection(.right)
            default: return .ignored
            }
            return .handled
        }
        .onKeyPress { keyPress in
            switch keyPress.key {
            case .upArrow: model.changeSnakeDirection(.up)
            case .downArrow: model.changeSnakeDirection(.down)
            case .leftArrow: model.changeSnakeDirection(.left)
            case .rightArrow: model.changeSnakeDirection(.right)
            default: return .ignored
            }
            return .handled
        }
    }
}

#Preview {
    BoardView()
}
