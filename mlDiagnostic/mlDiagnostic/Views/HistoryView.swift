//
//  HistoryView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import Fluent
import FluentSQLiteDriver
import SwiftUI

struct HistoryView: View {

    @EnvironmentObject var modelData: ModelData
    @State private var myError: MyError?

    var body: some View {
   
        NavigationView{
            VStack{
                Text("History").padding().font(.headline)
                
                    List {

                        if modelData.reports.isEmpty{
                            Text("No history yet, please create some test")
                        }
                        ForEach(modelData.reports, id: \.id) { r in
                            ReportRowView(reportId: r.id!).swipeActions {
                                Button("Delete") {
                                    modelData.deleteReport(report: r) { result in
                                        switch result {
                                        case .success():
                                            print("Report successfully deleted")
                                        case .failure(let error):
                                            print("Error deleting report: \(error)")
                                            myError = .deletionError
                                        }
                                    }
                                } .tint(.red)
                            }
                        }
                    }
            }
        
        } .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(item: $myError) { error in
                        Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
                    }
    }

}

//#Preview {
//    HistoryView()
//}
