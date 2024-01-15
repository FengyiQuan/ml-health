//
//  ClassificationLabel.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/27/23.
//

import SwiftUI

struct ClassificationLabel: View {
    var isRightEar: Bool
    var mlResult: String // MLResult

    var resultColor: Color {
        if mlResult.contains("A") {
            return Color.green
        }
        else if mlResult.contains("B") {
            return Color.yellow
        }
        else if mlResult.contains("C") {
            return Color.red
        } else {
            return Color.gray
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(stops: [
                    Gradient.Stop(color: resultColor, location: 0.25),
                    Gradient.Stop(color: .black, location: 0.25),
                ], startPoint: .top, endPoint: .bottom))
                .shadow(color: .white, radius: 3)
            VStack {
                Text(isRightEar ? "Right ear" : "Left ear")
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundStyle(resultColor)
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .shadow(color: resultColor, radius: 5)
                        .frame(width: 80, height: 80)
                    if mlResult.contains("A") {
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(resultColor)
                            .frame(width: 30, height: 30)
                    }
                    else if mlResult.contains("B") {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(resultColor)
                            .frame(width: 30, height: 30)
                    }
                    else if mlResult.contains("C") {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(resultColor)
                            .frame(width: 30, height: 30)
                    }
//                    Image(systemName: "checkmark")
//                        .resizable()
//                        .foregroundColor(resultColor)
//                        .frame(width: 30, height: 30)
                }.frame(width: 100, height: 100)
                if mlResult.contains("A") {
                    Text("TYPE A")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                else if mlResult.contains("B") {
                    Text("TYPE B")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                else if mlResult.contains("C") {
                    Text("TYPE C")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
            }.offset(x: 0, y: 10)
        }
        .frame(width: 150, height: 300)
        .padding()
    }
}
//
//#Preview {
//    ClassificationLabel(isRightEar: false)
//}
