// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "UnfoldSnake",
    platforms: [.macOS("15")],
    products: [
        .library(
            name: "SnakeLib",
            targets: ["Snake"]),
        .executable(
            name: "SnakeApp",
            targets: ["SwiftUISnakeMain"]),
    ],
    targets: [
        .target(
            name: "Snake"
        ),
        .testTarget(
            name: "UnfoldSnakeTests",
            dependencies: ["Snake"],
        ),
        .target(
            name: "SwiftUISnake",
            dependencies: ["Snake"],
        ),
        .executableTarget(
            name: "SwiftUISnakeMain",
            dependencies: ["SwiftUISnake"],
        )
    ]
)
