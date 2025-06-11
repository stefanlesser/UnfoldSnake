import SwiftUI
import SwiftUISnake

@main
struct GameOfSnake: App {
    var body: some Scene {
        WindowGroup {
            BoardView()
                .onDisappear { exit(0) }
        }
    }
}
