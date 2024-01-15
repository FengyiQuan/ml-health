//
//  Report.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/27/23.
//

import Fluent
import FluentSQLiteDriver
import Foundation

final class Report: Model,CustomStringConvertible {
    static let schema = "reports"

    @ID(key: .id)
    var id: UUID?
    @Parent(key: "participantId")
    var participantId: Participant
//    @Field(key: "completed")
//    var completed: Bool

    @OptionalChild(for: \.$leftEarStatusId)
    var leftEarStats: EarStats?
    @OptionalChild(for: \.$rightEarStatusId)
    var rightEarStats: EarStats?
    @Timestamp(key: "createdAt", on: .create)
    var timeStamp: Date?
    
    var description: String{
        "left: \($leftEarStats.description) \n right: \($rightEarStats.description)"
    }

    init() {
        self.timeStamp = Date()
//        self.completed = false
    }

    init(id: UUID? = nil, participantId: UUID, timeStamp: Date) {
        self.timeStamp = timeStamp
//        self.completed = completed
        self.id = id
        $participantId.id = participantId
    }

//    var completed: Bool {
//        true
////        $leftEarStats. != nil && $rightEarStats != nil
////        guard let leftEarStats = leftEarStats, let $rightEarStats else{
////            return false
////        }
////        $leftEarStats != nil && $rightEarStats != nil
//    }
}

struct CreateReportMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Report.schema)
            .id()
            .field("participantId", .uuid, .required)
//            .field("completed", .bool)
            .field("createdAt", .datetime)
            .foreignKey("participantId", references: "participants", "id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Report.schema)
            .delete()
    }
}
