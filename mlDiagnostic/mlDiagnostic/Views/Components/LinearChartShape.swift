//
//  LinearChartShape.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 11/8/23.
//

import Foundation
import SwiftUI


struct LineChartShape: Shape {
    var points: [Double]
    var animatableData: CGFloat
    var type: ChartType

    enum ChartType {
        case lineChart
        case verticalLine
        case horizontalLine
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let step = rect.width / CGFloat(points.count - 1)

        switch type {
        case .lineChart:
            for (index, point) in points.enumerated() {
                let x = step * CGFloat(index)
                let y = (CGFloat(point) / 2) * rect.height

                if index == 0 {
                    path.move(to: CGPoint(x: x, y: rect.height - y))
                } else {
                    let isPastAnimationPoint = x <= rect.width * animatableData
                    if isPastAnimationPoint {
                        path.addLine(to: CGPoint(x: x, y: rect.height - y))
                    }
                }
            }

        case .verticalLine:
            if let maxPointIndex = points.indices.max(by: { points[$0] < points[$1] }) {
                let x = step * CGFloat(maxPointIndex)
                if x <= rect.width * animatableData {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: rect.height))
                }
            }

        case .horizontalLine:
            let lastY = (CGFloat(points.last ?? 0) / 2) * rect.height
            let lastX = step * CGFloat(points.count - 1)
            if lastX <= rect.width * animatableData {
                path.move(to: CGPoint(x: 0, y: rect.height - lastY))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height - lastY))
            }
        }

        return path
    }
}
