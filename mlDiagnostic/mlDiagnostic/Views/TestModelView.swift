//
//  TestModelView.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 10/30/23.
//

import Foundation
import SwiftUI

struct TestModelView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var modelData: ModelData
    @State var participants: [Participant] = []
    @State var reports: [Report] = []
    @State var earStats: [EarStats] = []
    
    var body: some View {
        List {
            ForEach(participants, id: \.self) { participant in
                Text(participant.fName)
            }
            
            if !reports.isEmpty {
                Text(reports[0].id!.uuidString)
            }
            
            if !earStats.isEmpty {
                Text(earStats[0].isRight.description)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        participants = modelData.participants
        reports = modelData.reports
        earStats = modelData.earStats
    }
}

    
    

