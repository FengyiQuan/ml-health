//
//  mlDiagnosticApp.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 10/26/23.
//

import Fluent
import FluentSQLiteDriver
import SwiftUI

@main
struct mlDiagnosticApp: App {
    

    @StateObject var dbModel: AppModel = AppModel()
    @StateObject var bluetoothVM = BlueToothVM()
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dbModel)
                .environmentObject(dbModel.modelData)
                .environmentObject(bluetoothVM)
                .environmentObject(SessionManager())
                .onAppear {
                    print("app start")
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let docsDir = dirPaths[0]
                    print("db path: ", docsDir)
                }
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .background {
                        dbModel.stop()
                    }
                }
        }
    }
}
