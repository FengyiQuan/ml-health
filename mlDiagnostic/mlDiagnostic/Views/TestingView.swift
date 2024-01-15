//
//  MainView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

// BlueToothVM now has a published value_ready to indicate value update has finished.


import SwiftUI

struct TestingView: View {
//    @Binding var bluetoothVM
//        let forReport:Report
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var blueToothVM: BlueToothVM
    @EnvironmentObject var sessionManager: SessionManager
    @State var choosingRight: Bool
    //    @State private var participantID = ""
    @State private var testingEar = "Left"
    @State private var deviceName = ""
    @State private var manufacturer = ""
    @State private var firmwareVersion = ""
    @State private var hardwareVersion = ""
    @State private var softwareVersion = ""
    let isLocal:Bool
    var body: some View {

        if modelData.gotResults && modelData.newReport != nil{
            //        show result when result is generated
            ResultView (report: modelData.newReport!, isRightEar: choosingRight,isLocal: isLocal).environmentObject(blueToothVM)
        } else {
            //        show testing view when waiting for result
            testingView
        }
    }
    var testingView: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                    Text(blueToothVM.current?.name ?? "unknown service")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 150)
                .padding()
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: 300, height: 60)
                    .overlay(
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                
                                Image("bluetooth")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                    )
                testBtn
                if !modelData.gotResults {
                    Text("waiting for data")
                } else {
                    Text("data received")
                }
                
                deviceInfo
            }
        }.onAppear {
            deviceName = blueToothVM.current?.name ?? "unknown device"

        }
        
    }
    var testBtn: some View {
        Picker("Select State", selection: $modelData.gotResults) {
            ForEach(TransferStatus.allCases, id: \.self) { r in
                Text(r.rawValue).tag(r as TransferStatus?)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    var deviceInfo: some View {
        Form {
            HStack {
                Text("Participant ID:")
                Spacer()
                Text(modelData.currentUserId)
            }
            HStack {
                Text("Testing Ear:")
                Spacer()
                Text(choosingRight ? "Right" : "Left")
            }
            HStack {
                Text("Device Name:")
                Spacer()
                Text(deviceName)
            }
            HStack {
                Text("Manufacturer:")
                Spacer()
                Text(manufacturer)
            }
            HStack {
                Text("Firmware Version:")
                Spacer()
                Text(firmwareVersion)
            }
            HStack {
                Text("Hardware Version:")
                Spacer()
                Text(hardwareVersion)
            }
            HStack {
                Text("Software Version:")
                Spacer()
                Text(softwareVersion)
            }

        }
        .padding()
    }
    
}


//        .foregroundStyle(.white)

//
//#Preview {
//    TestingView(choosingRight: false)
//}
