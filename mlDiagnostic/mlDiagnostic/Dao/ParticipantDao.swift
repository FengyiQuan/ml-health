//
//  ParticipantDao.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 11/1/23.
//
import FluentSQLiteDriver
import Foundation


class ParticipantDao: DAO {
    //    typealias Entity = Participant
    let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func create(entity: Participant) -> Bool {
        do {
            try entity.save(on: database).wait()
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
//    func update(id:UUID, entity: Participant) -> Bool {
//        guard var currentEntity = self.get(id: id) else {
//            print("Entity not found.")
//            return false
//        }
//        currentEntity.fName = entity.fName
//        currentEntity.lName = entity.lName
//        currentEntity.$reports = entity.$reports
//        
//    }

    func get(username:String) -> Participant? {
        do {
            let participant = try Participant.query(on: database)
                .filter(\.$username == username)
                .first().wait()
            return participant
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    
    func get(id: UUID) -> Participant? {
        do {
            let participant = try Participant.query(on: database)
                .filter(\.$id == id)
                .first().wait()
            return participant
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    
    func delete(id: UUID) -> Bool {
        do {
            try Participant.query(on: database)
                .filter(\.$id == id)
                .delete().wait()
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
}
