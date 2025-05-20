import SwiftUI

struct Geo: Identifiable {
    var id = UUID()
    var start: CGPoint
    var end: CGPoint
}

struct ContentView: View {
    @State private var lines: [Geo] = []
    @State private var pen: CGPoint = .init(x: 200, y: 200)
    @State private var penAngle: Direction = .up
    private let stepSize: CGFloat = 20

    enum Direction {
        case left, right, up, down

        func move(from point: CGPoint, step: CGFloat) -> CGPoint {
            switch self {
            case .up:
                return CGPoint(x: point.x, y: point.y - step)
            case .down:
                return CGPoint(x: point.x, y: point.y + step)
            case .left:
                return CGPoint(x: point.x - step, y: point.y)
            case .right:
                return CGPoint(x: point.x + step, y: point.y)
            }
        }
    }

    enum Command: CaseIterable {
        case forward, backward, turnLeft, turnRight, turnUp, turnDown, clear

        var name: String {
            switch self {
            case .forward: return "F"
            case .backward: return "B"
            case .turnLeft: return "L"
            case .turnRight: return "R"
            case .turnUp: return "U"
            case .turnDown: return "D"
            case .clear: return "C"
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                ForEach(lines) { line in
                    Path { path in
                        path.move(to: line.start)
                        path.addLine(to: line.end)
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 400)
            .background(Color(.systemGray6))
            .border(Color.black)

            Spacer()

            HStack {
                ForEach(Command.allCases, id: \.self) { command in
                    Button(command.name) {
                        handle(command)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    private func handle(_ command: Command) {
        switch command {
        case .forward, .backward:
            let step = command == .forward ? stepSize : -stepSize
            let newPoint = penAngle.move(from: pen, step: step)
            lines.append(.init(start: pen, end: newPoint))
            pen = newPoint
        case .turnLeft:
            penAngle = .left
        case .turnRight:
            penAngle = .right
        case .turnUp:
            penAngle = .up
        case .turnDown:
            penAngle = .down
        case .clear:
            pen = .init(x: 200, y: 200)
            penAngle = .up
            lines.removeAll()
        }
    }
}

#Preview {
    ContentView()
}

