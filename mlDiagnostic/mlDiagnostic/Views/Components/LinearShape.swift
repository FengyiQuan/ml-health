//
//  LinearShape.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 11/8/23.
//

import SwiftUI

struct LineChartShape: Shape {
    var points: [UInt8]
    var animatableData: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let step = rect.width / CGFloat(points.count - 1)

        for (index, point) in points.enumerated() {
            let x = step * CGFloat(index)
            // Normalize UInt8 to the rect height
            let y = (CGFloat(point) / 255.0) * rect.height

            if index == 0 {
                path.move(to: CGPoint(x: x, y: rect.height - y))
            } else {
                let isPastAnimationPoint = step * CGFloat(index) <= rect.width * animatableData
                if isPastAnimationPoint {
                    path.addLine(to: CGPoint(x: x, y: rect.height - y))
                }
            }
        }

        return path
    }
}
