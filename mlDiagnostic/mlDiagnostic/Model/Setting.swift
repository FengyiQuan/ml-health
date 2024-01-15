//
//  Setting.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/27/23.
//

import Foundation
import Fluent

struct Setting {
    static let endpoint = "https://swsydieujd.us-east-1.awsapprunner.com"
    static let sqliteFileName = "app.sqlite"
    static let loggerFileName = "database.logger"
    static let appIconName = "AppImg"
    static let createTableMigrationList : [any Migration] = [CreateParticipantMigration(),CreateReportMigration(), CreateEarStatsMigration()]
    // TODO: may change this to other direcotry, not temp
    static let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent(sqliteFileName).absoluteString
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let fengyi = Participant(id: UUID(uuidString: "52D797C0-5528-4E78-84D7-70737CD5DC03"), username: "qfy", fName: "Fengyi", lName: "Quan", imageStr: nil)
    static let exampleA = ["tpp": 0, "ecv": 1.0, "sa": 1.00, "zeta": 2e-3, "slope": 5e-4]
    static let exampleB = ["tpp": -150, "ecv": 1.3, "sa": 0.08, "zeta": 2e-3, "slope": 8e-5]
    static let exampleC = ["tpp": -210, "ecv": 1.3, "sa": 0.60, "zeta": 2e-3, "slope": 5e-4]
    static let examples = [exampleA, exampleB, exampleC]

}
