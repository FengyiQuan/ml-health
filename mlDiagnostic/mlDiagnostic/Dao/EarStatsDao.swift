//
//  EarStatsDao.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 11/1/23.
//

import Fluent
//SQLiteDriver
import Foundation

//class EarStatsDao {
//    let database: Database
//    init(database: Database) {
//        self.database = database
//    }
//
//    func create(earStats: EarStats) -> Bool {
//        do {
//            try earStats.save(on: database).wait()
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//
//    /// create earStats for given report, it will check automatically assign to rightEarStats or leftEarStats based on earSttats.isRIght
//    func create(earStats: EarStats, forReport: Report) -> Bool {
//        do {
//            if earStats.isRight {
//                try forReport.$rightEarStats.create(earStats, on: database).wait()
//            } else {
//                try forReport.$leftEarStats.create(earStats, on: database).wait()
//            }
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//
//    func delete(id: UUID) -> Bool {
//        do {
//            try EarStats.query(on: database)
//                .filter(\.$id == id)
//                .delete().wait()
//            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
//    }
//}
// : DAO
class EarStatsDao {
    let database: Database
    init(database: Database) {
        self.database = database
    }

    func create(entity: EarStats) -> Bool {
        return false
//        do{
//            EarStats.query(on:database).with
//            return  database.transaction  { transaction in
//                try entity.save(on: transaction).flatMap{ _ in
//                    return entity.save(on: transaction)
//                    
//                }
//                
//            }
        
//    catch {
//                        print("Unexpected error: \(error).")
//                        return false
//                    }
//        do {
//            try database.transaction { transaction in
//                try entity.save(on: transaction).wait()
//                 
//                }
////            try entity.save(on: database).wait()
//            
////            return true
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
    }

    /// create earStats for given report, it will check automatically assign to rightEarStats or leftEarStats based on earSttats.isRIght
    func create(entity: EarStats, forReport: Report) -> Bool {
        do {
            if entity.isRight {
                try forReport.$rightEarStats.create(entity, on: database).wait()
            } else {
                try forReport.$leftEarStats.create(entity, on: database).wait()
            }
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
    func get(id: UUID) -> EarStats? {
        do {
            let earStats = try EarStats.query(on: database)
                .filter(\.$id == id)
                .first().wait()
            return earStats
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    func delete(id: UUID) -> Bool {
        do {
            try EarStats.query(on: database)
                .filter(\.$id == id)
                .delete().wait()
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
    func updateResult(id: UUID, result: MLResult) ->Bool {
        do {
            let stats = self.get(id: id)!
            stats.mlResult = result
            try stats.save(on: database).wait()
            print("result\(result)")
            return true
        }catch {
            print("Unexpected error: \(error).")
            return false
        }
        
        
    }
}
