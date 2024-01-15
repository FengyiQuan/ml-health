//
//  ErrorView.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 12/6/23.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.dismiss) var dismiss
    var error:String
    var body: some View {
        VStack{
            Text(error)
            Button("back"){
                dismiss()
            }
        }
        
    }
}

//#Preview {
//    ErrorView()
//}
