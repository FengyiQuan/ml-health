//
//  LoadingView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct LoadingView: View {

    @State var isLoading: Bool = true
    @State private var isSpinning = false

    private let circleLineWidth: CGFloat = 8
    private let loadingDeadline = 2.5
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !self.isLoading {
                StartView()
            } else {
                loadingProgess
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingDeadline) {
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }

    private var loadingProgess: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(LinearGradient(gradient: Gradient(colors: [.black, .red]), startPoint: .top, endPoint: .bottom), lineWidth: circleLineWidth)
                .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isSpinning)
            Circle()
                .trim(from: 0.5, to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color("LightGreen"), .black]), startPoint: .top, endPoint: .bottom), lineWidth: circleLineWidth)
                .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isSpinning)
            ZStack{
                Circle()
                    .fill(Color("LightGreen"))
                    .shadow(radius: 7)
                    .frame(width: 130, height: 130)
                
                Text("AI Tymp")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
           
        }
        .frame(width: 150, height: 150)
        .padding()
        .onAppear {
            self.isSpinning.toggle()
        }
    }
}

//#Preview {
//    LoadingView()
//}
