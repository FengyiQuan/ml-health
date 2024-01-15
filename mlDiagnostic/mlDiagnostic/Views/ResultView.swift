//
//  ResultView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var report: Report
//    @State var ecv: Double? = 0.0
//    @State var tpp: Double? = 0.0
    var sa: Double? = -117.56
    @State var isRightEar:Bool
    var isLocal:Bool
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var dbModel: AppModel
    @EnvironmentObject var blueToothVM: BlueToothVM
    @State private var showClassification = false
    @State var showDetail = false
    @State private var myError: MyError?
    @State var errorEncountered = 0
    

    var leftStats: EarStats? {
        if let id = report.id {
            dbModel.reportDao.get(id: id)?.leftEarStats
        } else {
            nil
        }
    }
    var rightStats: EarStats? {
        if let id = report.id {
            print(dbModel.reportDao.get(id: id)?.rightEarStats as Any)
            return dbModel.reportDao.get(id: id)?.rightEarStats
            
        } else {
            return nil
        }
    }
    private var reportCompleted: Bool {
        leftStats != nil && rightStats != nil
    }
    var body: some View {
        NavigationView{
            VStack {
                Text("Result")
                    .font(.title)
                plot
                status
              
                
                if reportCompleted {
                    earToggle
                }
                StyledButton(title: "show data detail"){
                    showDetail.toggle()
                }.frame(alignment: .leading).buttonStyle(.bordered)
                if !reportCompleted {
                    testEarBtn
                }
                if reportCompleted {
                    classifyBtn
                }
               
                
            }.sheet(isPresented: $showClassification) {
                ClassificationView(reportid: report.id!)
            }.sheet(isPresented: $showDetail) {
                ResultDetailView(DismissAction: {})
            }.alert(item: $myError) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")){
                    sessionManager.isLoggedIn.toggle()
                    sessionManager.selection = 2
                })
                    }
        }
            
        
        
        
    }

    private var plot: some View {
        VStack{
//            Text("this is the plot")

//            show plot when data is collected
            if !isRightEar {
                if leftStats != nil {
                    PlotView(byteArray1:leftStats!.data!)
                }
            } else {
                if rightStats != nil {
                    PlotView(byteArray1:rightStats!.data!)
                }
                
            }
           
        }.frame(width:350, height: 300)
        
        
    }
    
    private var status: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .frame(width: 100, height: 100)
                    .shadow(color: .purple, radius: 5)
                VStack {
                    Text("ECV").foregroundStyle(.purple)
                    if isRightEar {
                        Text(toStr(modelData.newRightResult?.ECV)).foregroundStyle(.purple)
                    } else {
                        Text(toStr(modelData.newLeftResult?.ECV)).foregroundStyle(.purple)
                    }
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .frame(width: 100, height: 100)
                    .shadow(color: .orange, radius: 5)
                VStack {
                    Text("TPP").foregroundStyle(.orange)
                    if isRightEar {
                        Text(toStr(modelData.newRightResult?.TPP)).foregroundStyle(.orange)
                    } else {
                        Text(toStr(modelData.newLeftResult?.TPP)).foregroundStyle(.orange)
                    }
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue, radius: 5)
                VStack {
                    Text("SA").foregroundStyle(.blue)
                    Text(toStr(sa)).foregroundStyle(.blue)
                }
            }
        }
    }
    
    private var earToggle: some View {
        HStack {
            Text("Left Ear")
                .foregroundColor(isRightEar ? .secondary : .primary)
            
            Toggle("", isOn: $isRightEar)
                .frame(width: 100)
                .tint(.red)
                .labelsHidden()
            
            Text("Right Ear")
                .foregroundColor(isRightEar ? .primary : .secondary)
        }
        .padding()
    }
    
    private var testEarBtn: some View {
        StyledButton(title: leftStats == nil ? "test left ear" : "test right ear") {
            if (leftStats == nil) {
                classifyHelper(isLocal: isLocal, isRight: false)
            }
            else  {
                classifyHelper(isLocal: isLocal, isRight: true)
            }
            
        }.onAppear {
            if !reportCompleted {
                isRightEar = leftStats == nil
            }
            
            
        }
    }
    //
    private var classifyBtn: some View {
            StyledButton(title: "classify results", action: {
                showClassification.toggle()
            })
        
    }
    //
    private func toStr(_ optionalDouble: Double?) -> String {
        if let unwrappedDouble = optionalDouble {
            let doubleString = String(format: "%.2f", unwrappedDouble)
            return doubleString
        } else {
            let nanString = "nan"
            return nanString
        }
    }
    func classifyHelper(isLocal:Bool, isRight:Bool){
        modelData.classify(local: isLocal, isRight: isRight) { success in
            if success {
//                create left / right ear Stats for the report
                var newEarStats:EarStats?
                if isRight {
                    newEarStats = EarStats(isRight: isRight,data:modelData.newRightResult!.compliance, mlResult:MLResult(rawValue: modelData.newRightResult!.tympType)!)
                } else {
                    newEarStats = EarStats(isRight: isRight,data:modelData.newLeftResult!.compliance, mlResult:MLResult(rawValue: modelData.newLeftResult!.tympType)!)
                }
//                save the earStats in the database and memory
                let _ = modelData.earStats.append(newEarStats!)
                let _ = dbModel.earStatsDao.create(entity: newEarStats!, forReport: report)
                print("Classification successful")
                isRightEar.toggle()
            } else {
//                if failed, allow retry for 5 times
                print("Classification failed, trying again")
                self.errorEncountered = errorEncountered + 1
                if errorEncountered <= 5 {
                    classifyHelper(isLocal:isLocal, isRight: isRight)
                } else {
                    myError = .classificationError
                }
            }
            
        }
    }
    //}
    
    //#Preview {
    //    ResultView(report: Report(id: UUID(), participantId: UUID(), timeStamp: Date()))
    //}
}
