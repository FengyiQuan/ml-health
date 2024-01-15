//
//  ConnectionStatus.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import Foundation

enum ConnectionStatus: String {
    case Connecting = "Connecting"
    case Connected = "Connected"
}

enum TransferStatus: String,CaseIterable {
    case WaitingData
    case Preparing
    case Finished
}
