//
//  TabView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var modelData: ModelData
    @State var uiImage: UIImage? = UIImage(named:"AppImg")!

    var body: some View {
        TabView(selection: $sessionManager.selection) {
            HomeView(image:$uiImage)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }.tag(0)

                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }.tag(1)

                TestView()
                    .tabItem {
                        Label("Test", systemImage: "testtube.2")
                    }.tag(2)

        } .onAppear {
            if let _ = modelData.currentUser?.image{
                uiImage = modelData.currentUser?.uiImage
            }
        }
        }
}
