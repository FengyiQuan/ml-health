//
//  SessionManager.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 12/5/23.
//

import Foundation
// manage navigation link and tab view selection
class SessionManager: ObservableObject {
//    change rootId to reset navigation view stack
    var isLoggedIn: Bool = false {
        didSet {
            DispatchQueue.main.async {
                 self.rootId = UUID()
             }
        }
    }
    
    @Published var rootId: UUID = UUID()
    @Published var selection:Int = 0
    
}
