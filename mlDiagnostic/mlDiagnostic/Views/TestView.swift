//
//  TestView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI


struct TestView: View {
    
    @EnvironmentObject var blueToothVM: BlueToothVM
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var appModel: AppModel
    @State private var choosingRight: Bool? = false
    @State private var isLocal: Bool = false
    @State var connStatus: ConnectionStatus = .Connected
    @State private var showConnect = false
    @State private var compliance:[Double]?
    @EnvironmentObject var sessionManager:SessionManager
    @State var errorEncountered = 0
    @State private var myError: MyError?
    @State private var showHelp:Bool = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                Text("Test")
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom)
                ScrollView {
                    ZStack {
                        VStack {
                            
                            testView.padding(.top)
                        }
                    }
                }
                .padding(.top)
                .frame(width: UIScreen.main.bounds.width)
                    .background(Color(UIColor.systemGray6))
            }
            
        }
        .id(sessionManager.rootId)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert(item: $myError) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")){
                sessionManager.isLoggedIn.toggle()
                sessionManager.selection = 2
            })
        }
        
    }
    
    private let chosenColor: Color =  Color(UIColor.gray)
    //    private let chosenColor: Color =  Color(red: 69, green: 69, blue: 69)#colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
    private let bgColor: Color = .black
    var testView: some View {
        VStack {
            HStack {
                Button(action: {
                    choosingRight = false
                }) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill((choosingRight ?? true) ? bgColor : chosenColor)
                    //                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 150, height: 300)
                        .shadow(color: .white, radius: 3)
                    
                        .overlay(
                            VStack {
                                Image(systemName: "ear")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(x: -1, y: 1)
                                    .foregroundColor(Color("LightGreen"))
                                    .frame(width: 50, height: 50)
                                
                                Text("Left")
                                    .textCase(.uppercase)
                                    .foregroundStyle(.white)
                            })
                }
                Button(action: {
                    choosingRight = true
                }) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill((choosingRight ?? false) ? chosenColor : bgColor)
                        .frame(width: 150, height: 300)
                        .shadow(color: .white, radius: 3)
                        .overlay(
                            VStack {
                                Image(systemName: "ear")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 50, height: 50)
                                
                                Text("Right")
                                    .textCase(.uppercase)
                                    .foregroundStyle(.white)
                            })
                }
            }
            toggle
            if let _ = blueToothVM.current {
                //                if bluetooth connected, can start test
                if let choosingRight = choosingRight {
                    NavigationLink(destination: TestingView(blueToothVM: _blueToothVM, choosingRight: choosingRight, isLocal:isLocal))
                    {
                        StyledButton(title: "Start Test", action: nil)
                    }.simultaneousGesture(TapGesture().onEnded{classifyHelper(isLocal: isLocal, isRight: choosingRight)})
                } else {
                    StyledButton(title: "Start Test", action: nil)
                }
                //                if bluetooth not connected, connect first
            } else {
                StyledButton(title: "Connect to BlueTooth", action: { showConnect = true })
            }
            StyledButton(title: "Help", image:Image(systemName: "info.circle.fill"), action: {showHelp.toggle()})
            
            
        }.sheet(isPresented: $showConnect, content: {
            BlueToothConnectView().environmentObject(blueToothVM)
        }).sheet(isPresented: $showHelp, content: {
            HelpView()
        })
    }
    var toggle: some View {
        HStack {
            Text("Remote")
                .foregroundColor(isLocal ? .secondary : .primary)
            
            Toggle("", isOn: $isLocal)
                .frame(width: 100)
                .tint(.red)
                .labelsHidden()
            
            Text("Local")
                .foregroundColor(isLocal ? .primary : .secondary)
        }
        .padding()
    }
    
    func classifyHelper(isLocal:Bool, isRight:Bool){
        modelData.classify(local: isLocal, isRight: isRight) { success in
            if success {
                //                create new report and save it in database and memory
                let newReport = Report(participantId: modelData.currentUser!.id!, timeStamp: Date())
                let _ = appModel.reportDao.create(entity: newReport, forParticipant: modelData.currentUser!)
                modelData.newReport = newReport
                modelData.reports.append(newReport)
                print("newreport created")
                //                read current data from bluetooth
                blueToothVM.updateValue()
                print("Classification successful")
                //                create new earStats for the new report
                let newEarStats:EarStats?
                if !choosingRight! {
                    newEarStats = EarStats(isRight: isRight,data: modelData.newLeftResult!.compliance, mlResult:MLResult(rawValue: modelData.newLeftResult!.tympType)!)
                } else {
                    newEarStats = EarStats(isRight: isRight,data: modelData.newRightResult!.compliance, mlResult:MLResult(rawValue: modelData.newRightResult!.tympType)!)
                }
                
                //                save earStats in database and memory
                let _ = appModel.earStatsDao.create(entity: newEarStats!, forReport:modelData.newReport!)
                let _ = modelData.earStats.append(newEarStats!)
                
            } else {
                print("Classification failed, trying again")
                //                allow 5 times max retry
                //                if all of them failed, alert error message
                self.errorEncountered = errorEncountered + 1
                if errorEncountered <= 5 {
                    classifyHelper(isLocal:isLocal, isRight: isRight)
                } else {
                    myError = .classificationError
                }
            }
        }
    }
}

// #Preview {
//    TestView(record:Report(id: UUID(), participantId: UUID(), timeStamp: Date()))
// }
