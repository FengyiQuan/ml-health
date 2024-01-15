//
//  DBTest.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/26/23.
//

import FluentSQLiteDriver
import Foundation
import NIOCore
// import PostgresNIO
//
// let config = PostgresConnection.Configuration(
//  host: "localhost",
//  port: 5432,
//  username: "my_username",
//  password: "my_password",
//  database: "my_database",
//  tls: .disable
// )
import SwiftUI



final class AppModel: ObservableObject {
    let databases: Databases
    private var eventLoopGroup: MultiThreadedEventLoopGroup
    private var threadPool: NIOThreadPool
    
    var participantDao: ParticipantDao
    
    var reportDao: ReportDao
    var earStatsDao: EarStatsDao
    init() {
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        threadPool = NIOThreadPool(numberOfThreads: System.coreCount)
        threadPool.start()
//        create connection to the database
        databases = Databases(threadPool: threadPool, on: eventLoopGroup)
        databases.use(.sqlite(.file(Setting.dbPath)), as: .sqlite)
        databases.default(to: .sqlite)
        
        database = databases.database(
            logger: logger,
            on: databases.eventLoopGroup.next()
        )!
//        init DAO for interact with database
        participantDao = ParticipantDao(database: database)
        reportDao = ReportDao(database: database)
        earStatsDao = EarStatsDao(database: database)
//        migrate table
        initTable()
//        add some default data
        initData()

    }
    
    var logger: Logger = {
        var logger = Logger(label: Setting.loggerFileName)
        logger.logLevel = .trace
        return logger
    }()
    
    var database: Database
    
    lazy var modelData: ModelData = .init(database: database)
    
    private func initTable() {
//        if need to drop tables
//        let reversedMigrations = Setting.createTableMigrationList.reversed()
//        for m in reversedMigrations {
//            do {
//                try m.revert(on: database).wait()
//            } catch {
//                print("error \(error)")
//            }
//        }
//        create tables
        for m in Setting.createTableMigrationList {
            do {
                try m.prepare(on: database).wait()
            } catch {
                print("error \(error)")
            }
        }
    }
    
    private func initData() {

        let participant = Setting.fengyi
        _ = participantDao.create(entity: participant)
    
    }
//    examples for transaction
//    private func createReportAndEarStats(participantId participantId: UUID) -> EventLoopFuture<Bool> {
//        database.transaction { transaction in
//            let newReport = Report(participantId: participantId, timeStamp: Date())
//            
//            let leftEarStats = EarStats(isRight: false, data: [1, 2, 3, 4, 5, 6,3,3,6,1,1,4,3,6,6], mlResult: .typeB)
//            let rightEarStats = EarStats(isRight: true, data: [1, 2, 77, 5, 2, 2, 3, 4, 5, 6], mlResult: .typeA)
//            
//            return newReport.save(on: transaction).flatMapThrowing {
//                let reportId = try newReport.requireID()
//                leftEarStats.$leftEarStatusId.id = reportId
//                rightEarStats.$rightEarStatusId.id = reportId
//                
//                return (leftEarStats, rightEarStats)
//            }.flatMap { (leftEarStats, rightEarStats) in
//                leftEarStats.save(on: transaction).and(rightEarStats.save(on: transaction))
//            }.transform(to: true)
//                .flatMapError { error in
//                    return transaction.eventLoop.makeSucceededFuture(false)
//                }
//        }
//    }
//    private func saveTransaction(existedReport: Report?, earStats: EarStats, forPartcipant: Participant) {
//        guard let report = existedReport else {
//            var report = Report(participantId: forPartcipant.id!, timeStamp: Date())
//            reportDao.create(entity: report, forParticipant: forPartcipant)
//            earStatsDao.create(entity: earStats, forReport: report)
//            return
//        }
//        earStatsDao.create(entity: earStats, forReport: report)
//    }
//    private func testTransaction() {
//        let participant: Participant? = participantDao.get(id: UUID(uuidString: "52D797C0-5528-4E78-84D7-70737CD5DC03")!)
//        let newReport = Report(participantId: UUID(uuidString: "52D797C0-5528-4E78-84D7-70737CD5DC03")!, timeStamp: Date())
//        reportDao.create(entity:newReport, forParticipant: participant!)
//        let leftEarStats = EarStats(isRight: false, data: [1, 2, 3, 4, 5, 6], mlResult: .typeB)
//        let rightEarStats = EarStats(isRight: true, data: [1, 2, 77, 5, 2, 2, 3, 4, 5, 6], mlResult: .typeA)
//        saveTransaction(existedReport: newReport, earStats: leftEarStats, forPartcipant: participant!)
//        saveTransaction(existedReport: newReport, earStats: rightEarStats, forPartcipant: participant!)
//    }
//    
    
//    read data from database
    private func queryData() {
        Participant.query(on: database).all().whenComplete { result in
            switch result {
            case .success(let participants):
                for participant in participants {
                    print(participant)
                }
            case .failure(let error):
                print("Error querying participants: \(error)")
            }
        }
        Report.query(on: database).all().whenComplete { result in
            switch result {
            case .success(let reports):
                for report in reports {
                    print(report)
                }
            case .failure(let error):
                print("Error querying ear stats: \(error)")
            }
        }
        EarStats.query(on: database).all().whenComplete { result in
            switch result {
            case .success(let earStats):
                for stat in earStats {
                    print(stat)
                }
            case .failure(let error):
                print("Error querying ear stats: \(error)")
            }
        }
    }
    
    func stop() {
        do {
            print("cleanup resources")
            try eventLoopGroup.syncShutdownGracefully()
            try threadPool.syncShutdownGracefully()
        } catch {
            print("Error shutting down \(error.localizedDescription)")
            exit(0)
        }
        print("Client connection closed")
    }
}
