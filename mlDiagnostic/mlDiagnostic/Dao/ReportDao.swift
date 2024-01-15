//
//  ReportDao.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 11/1/23.
//

import FluentSQLiteDriver
import Foundation
//
//class ReportDao {
//    let database: Database
//    init(database: Database) {
//        self.database = database
//    }
//
//    func create(report: Report) -> Bool {
//        do {
//            try report.save(on: database).wait()
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//
//    func create(report: Report, forParticipant: Participant) -> Bool {
//        do {
//            try forParticipant.$reports.create(report, on: database).wait()
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//
//    func delete(id: UUID) -> Bool {
//        do {
//            try Report.query(on: database)
//                .filter(\.$id == id)
//                .delete().wait()
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//}

class ReportDao:DAO {
    let database: Database
    init(database: Database) {
        self.database = database
    }
    
    func create(entity: Report) -> Bool {
        do {
            try entity.save(on: database).wait()
            
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    } 
    func create(entity: Report, forParticipant: Participant) -> Bool {
        do {
            try forParticipant.$reports.create(entity, on: database).wait()
            return true
        }
        catch {
            return false
        }
    }

//    func update(entity: Report) -> Bool {
//        do {
//
//            if let existingReport = try Report.find(entity.id, on: database).wait() {
//
//
//                try existingReport.save(on: database).wait()
//                return true
//            } else {
//                print("Record not found.")
//                return false
//            }
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }

    
    func get(id: UUID) -> Report? {
        do {
            let report = try Report.query(on: database)
                .filter(\.$id == id)
                .with(\.$leftEarStats)
                .with(\.$rightEarStats)
                .first().wait()
            return report
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    
    func delete(id: UUID) -> Bool {
        do {
            try Report.query(on: database)
                .filter(\.$id == id)
                .delete().wait()
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
}
