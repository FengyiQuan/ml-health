//
//  ClassificationView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct ClassificationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var appModel: AppModel
    let reportid: UUID

    var report:Report {
        appModel.reportDao.get(id: reportid)!
    }
    var body: some View {
        ZStack {
            VStack {
                Text("Classification")
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                classifiedTypes
                Spacer()
                retestBtn
                endBtn
                Spacer()
            }
        }
//
    }
    private var classifiedTypes: some View {
        HStack{
            if report.leftEarStats != nil {
                ClassificationLabel(isRightEar: false, mlResult: report.leftEarStats!.mlResult.rawValue)
            }
//            Spacer()
            if report.rightEarStats != nil {
                ClassificationLabel(isRightEar: true, mlResult: report.rightEarStats!.mlResult.rawValue)
            }
        }
    }

    private var retestBtn: some View {
       
        StyledButton(title: "re-test"){

                modelData.reset()
                dismiss()

                sessionManager.isLoggedIn.toggle()
                sessionManager.selection = 2
            
        }

        
                           
        
    }


    private var endBtn: some View {
        StyledButton(title: "Close") {
            // TODO:
            dismiss()
        }
    }
}

//#Preview {
//    ClassificationView()
//}
