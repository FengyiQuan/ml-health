//
//  DAO.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 11/2/23.
//

import Foundation
import FluentSQLiteDriver

protocol DAO {
    associatedtype Entity
    var database: Database { get }

    func create(entity: Entity) -> Bool
    func get(id: UUID) -> Entity?
    func delete(id: UUID) -> Bool
//    func update(id: UUID, entity:Entity)
}
