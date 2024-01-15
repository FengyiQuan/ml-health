//
//  File.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 10/28/23.
//

import FluentSQLiteDriver
import Foundation
import SwiftUI

final class EarStats: Model, CustomStringConvertible {
    static let schema = "earStats"
    @ID(key: .id)
    var id: UUID?
    @Field(key: "isRight")
    var isRight: Bool
    @Field(key: "data")
    var data: [Double]?
    @Enum(key: "result")
    var mlResult: MLResult
    @OptionalParent(key: "leftEarStatusId")
    var leftEarStatusId: Report?
    @OptionalParent(key: "rightEarStatusId")
    var rightEarStatusId: Report?

    init() {}

    init(id: UUID? = nil, isRight: Bool, data: [Double]?, mlResult: MLResult = .empty) {
        self.id = id
        self.isRight = isRight
        self.data = data
        self.mlResult = mlResult
    }

//    func createEarStats(forReport report:Report,){
//        report.$leftEarStats.create(EarStats, on: database)
//    }

    var description: String {
        "\(mlResult)"
    }
}

struct CreateEarStatsMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(EarStats.schema)
            .id()
            .field("isRight", .bool, .required)
            .field("data", .array(of: .double))
            .field("result", .string)
            .field("leftEarStatusId", .uuid)
            .field("rightEarStatusId", .uuid)
            .foreignKey("leftEarStatusId", references: "reports", "id", onDelete: .cascade)
            .foreignKey("rightEarStatusId", references: "reports", "id", onDelete: .cascade)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(EarStats.schema)
            .delete()
    }
}
