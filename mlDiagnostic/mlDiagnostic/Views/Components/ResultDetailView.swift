//
//  PlaceHolderView.swift
//  mlDiagnostic
//
//  Created by Fall 2023 on 10/29/23.
//

import SwiftUI

struct ResultDetailView: View {
    
    @EnvironmentObject var blueToothVM: BlueToothVM
    @Environment(\.dismiss) var dismiss
    var DismissAction: ()->Void
    var body: some View {
        VStack {
            
            Text("Current Device: \(blueToothVM.current?.name ?? "Unknown Device")")
            HStack {
                Text("Services:")
                    .font(.title)
                Spacer()
            }.padding(10)
            
            List {
                
                
                ForEach(blueToothVM.current?.services ?? [], id: \.uuid) { service in
                    Section(header: Text("Service: \(service.uuid.description)")) {
                        ForEach(service.characteristics ?? [], id: \.uuid) { characteristic in
                            Text("Characteristic: \(characteristic.uuid.description)")
                            Text("Value Size: \(getValueSize(characteristic)) byte(s)")
                            Text("Value: \(getValueString(characteristic))")
                            getUIntVals(characteristic)
                            
                        }
                    }
                }
            }
            Button("Close",systemImage: "xmark.circle",action:{dismiss()})
            
            //            if let current = blueToothVM.current {
            //                VStack {
            //                    Button(
            //                        action: {
            //                            blueToothVM.updateValue()
            //                        }, label : {
            //                            Text("Update Value")
            //                        }
            //                    )
            //                    Button(
            //                        action: {
            //                            blueToothVM.disconnect(current)
            //                            DismissAction()
            //                        }, label: {
            //                            Text("Disconnect")
            //
            //                        }
            //                    )
            //                }
            //            }
        }
    }
}

//#Preview {
//    PlaceHolderView(DismissAction: {}).environmentObject(BlueToothVM())
//}
