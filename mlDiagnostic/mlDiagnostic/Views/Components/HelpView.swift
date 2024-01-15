//
//  HelpView.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 12/7/23.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Help Guide")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)

                Group {
                    Text("1. Please click 'Connect to Bluetooth'.")
                    Text("2. In the pop-up window, choose 'DukeTymp' and click 'Select DukeTymp'.")
                    Text("3. If you do not see 'DukeTymp', please ensure the device is powered on with light 1 on or blinking, then reboot the app.")
                    Text("4. Choose the ear you want to test first.")
                    Text("5. Choose either to classify the result remotely or use the local model. The remote server can analyze the result more precisely, but it requires internet access.")
                    Text("6. Click 'Start Test'.")
                }
                .font(.body)

                Spacer()

                Button(action: { dismiss() }) {
                    Label("Close", systemImage: "xmark.circle")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
    }
}


#Preview {
    HelpView()
}
