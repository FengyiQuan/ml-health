//
//  Button.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct StyledButton: View {
    var title: String
    var image:Image?
    var action: (() -> Void)?
    var backgroundColor: Color = .init("LightGreen")
    var cornerRadius: CGFloat = 30

    var body: some View {
        if let action = action {
            Button(action: {
                action()
            }) {
                btnLabel
            }
            .frame(width: 300, height: 60)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)

        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                .fill(backgroundColor)
                .frame(width: 300, height: 60)
                .overlay(btnLabel)
        }
    }

    private var btnLabel: some View {
//        Image(systemName: "info.circle.fill")
        HStack{
            if image != nil{
                image
            }
            Text(title)
                .font(.headline)
                .textCase(.uppercase)
                .foregroundStyle(.white)
        }
            
    }
}

#Preview {
    VStack {
        StyledButton(title: "TEST") {}
        StyledButton(title: "TEST", action: nil)
    }
}
