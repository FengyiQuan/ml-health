//
//  Participant.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import Fluent
import FluentSQLiteDriver
import Foundation
import SwiftUI

// users
final class Participant: Model, Hashable {
    static let schema = "participants"
    @ID(key: .id)
    var id: UUID?
    @Field(key: "username")
    var username: String
    @Field(key: "fName")
    var fName: String
    @Field(key: "lName")
    var lName: String
//    @Field(Key:"gender")
//    var gender:
    @Field(key: "imageStr")
    var imageStr: String?
    @Children(for: \.$participantId)
    var reports: [Report]
    // other info
    var uiImage: UIImage {
        return base64toUIImage(base64pic: imageStr)
    }

    var image: Image {
        Image(uiImage: uiImage)
    }

    init() {
        self.imageStr = nil
    }

    init(id: UUID? = nil, username: String, fName: String, lName: String, imageStr: String? = nil) {
        self.id = id
        self.username = username
        self.fName = fName
        self.lName = lName
        self.imageStr = imageStr
    }

    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func setUIImageStr(uiImage:UIImage) {
        self.imageStr = imgToString(img: uiImage)
    }
}

struct CreateParticipantMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Participant.schema)
            .id()
            .field("username", .string, .required)
            .field("fName", .string, .required)
            .field("lName", .string)
            .field("imageStr", .string)
            .unique(on: "username")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Participant.schema)
            .delete()
    }
}
