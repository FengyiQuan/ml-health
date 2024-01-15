//
//  RecordRowView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct ReportRowView: View {
    @EnvironmentObject var appModel:AppModel
    enum Action {
        case detail
        case edit
    }

    var reportId: UUID
    @State var report:Report?

    var body: some View {
        VStack{
            if report != nil{
                NavigationLink(destination: ResultView(report: report!, isRightEar: false,isLocal: true)) {
                    VStack(alignment: .leading, spacing: 20) {
                        //            HStack(alignment: .top, spacing: 8) {
                        HStack{
                            if report!.leftEarStats != nil {
                                Text("Left ear result:Type \(report!.leftEarStats!.mlResult.rawValue)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if report!.rightEarStats != nil {
                                Text("Right ear result:Type \(report!.rightEarStats!.mlResult.rawValue)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        HStack(alignment: .bottom) {
                            Text("Test Created At: ")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
//                            Spacer()
                            Text(report!.timeStamp!, formatter: dateFormatter)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
            }
        }.onAppear{
            report = appModel.reportDao.get(id: reportId)
    }
    }
//        .swipeActions(allowsFullSwipe: false) {
//            Button("Delete") {
//                let res = db.delete(person.DUID)
//                if res {
//                    showingInfo = true
//                }
//            }
//            .tint(.red)
//
//            Button("Edit") {
//                addEditViewShown = true
//            }
//
//            .tint(.blue)
//        }
//
//        .sheet(isPresented: $addEditViewShown) {
//            AddEditView(addEditViewShown: $addEditViewShown, showingInfo: $showingInfo, fName: person.fName, lName: person.lName, DUID: person.DUID, netid: person.netid, email: person.email, from: person.from, gender: person.gender, role: person.role, hobby: person.hobby, languages: person.languages, movie: person.movie, team: person.team, program: person.program, plan: person.plan,
//                                                image: person.uiImage,
//                        addNew: false)
//        }
}

//#Preview {
//    ReportRowView(report: Report(id: UUID(), participantId: UUID(), timeStamp: Date()))
//}
