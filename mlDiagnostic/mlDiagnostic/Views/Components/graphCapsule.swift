import SwiftUI
struct GraphDot: View, Equatable {
    var index: Int
    var color: Color
    var diameter: CGFloat
    var value: UInt8
    var maxValue: UInt8

    var body: some View {
        Circle()
            .fill(color)
            .offset(x: 0, y: -CGFloat(value) / CGFloat(maxValue) * diameter)
            .animation(.easeInOut(duration: 0.2), value: value)
    }
}
