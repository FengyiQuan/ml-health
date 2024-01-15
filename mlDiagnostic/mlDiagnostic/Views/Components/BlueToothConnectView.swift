//
//  BlueToothConnectView.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 10/26/23.
//

import SwiftUI


struct BlueToothConnectView: View {
    
    @EnvironmentObject var blueToothVM: BlueToothVM
    @EnvironmentObject var sessionManager: SessionManager
    @State private var blueToothStatusPrompt = false
    @Environment(\.dismiss) var dismiss
    @State private var showGray = false
    
    var body: some View {
        
        VStack {

            Text("Found \(blueToothVM.inRange.count) device(s) in range")
           
            Button(
                action: {
                    blueToothStatusPrompt = true
                }, label: {
                    Text("Verify BlueTooth Status")
                }
            )
            
            HStack{
                Text("In Range: ")
                    .font(.title)
                Spacer()
            }.padding(10)
            List(Array(blueToothVM.inRange.values).filter { $0.name == "DukeTymp" }, id: \.self) { peripheral in 
                Button(
                    action: {
                        showGray.toggle()
                        blueToothVM.connect(peripheral)
                    }, label: {
                        if showGray {
                            Text(peripheral.name ?? "unknown service") .foregroundStyle(.gray)
                        } else {
                            Text(peripheral.name ?? "unknown service")
                        }
                    }
                )
            }
            HStack{
                Text("Connected: ")
                    .font(.title)
                Spacer()
            }.padding(10)
            List(Array(blueToothVM.connected.values), id: \.self) { peripheral in
                Button(
                    action: {
                        blueToothVM.current = peripheral
                        blueToothVM.current?.discoverServices(nil)
                        sessionManager.selection = 2
                        dismiss()
                      
                    }, label: {
                        Text("select \(peripheral.name ?? "unknown service")")
                    }
                )
            }
            HStack{
                Text("Log: ")
                    .font(.title)
                Spacer()
            }.padding(10)
            List(blueToothVM.log, id:\.self) {l in
                Text(l.description + "\n")
            }
            
        }.alert(isPresented: $blueToothStatusPrompt) {
            Alert(title: {Text("BlueTooth Status")}(), message: {Text("The device is \(getDeviceStatus(blueToothVM.centralState))")}())
        }

        .padding()
    }
}

struct BlueToothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            BlueToothConnectView().environmentObject(BlueToothVM())
        }
    }
}
