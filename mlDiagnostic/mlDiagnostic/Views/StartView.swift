//
//  Home.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct StartView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    tmlpCircle
                    NavigationLink(destination: LoginView()) {
                        Text("Start")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("LightGreen"))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    private var tmlpCircle: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("LightGreen"))
            Text("Tymp")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
        .padding()
    }
}

//#Preview {
//    StartView()
//}
