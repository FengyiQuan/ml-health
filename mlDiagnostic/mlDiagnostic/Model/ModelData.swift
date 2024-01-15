//
//  DataModel.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 10/29/23.
//

import FluentSQLiteDriver
//
import Foundation
import NIOCore
import UIKit



struct ClassificationResponse: Codable {
    var tympType: String
    var ECV: Double
    var TPP: Double
    var ECV_std: Double
    var TPP_std: Double
    var pressure: [Double]
    var compliance: [Double]
}

class ModelData: NSObject, ObservableObject, URLSessionDataDelegate {
    @Published var currentUser: Participant?
    var currentUserId: String {
        guard let currentUser = currentUser else {
            return ""
        }
        guard let id = currentUser.id else {
            return ""
        }
        return id.uuidString
    }
    
    @Published var participants: [Participant] = []
    @Published var earStats: [EarStats] = []
    @Published var reports: [Report] = []
    
    @Published var newReport: Report?
    @Published var newLeftResult: ClassificationResponse?
    @Published var newRightResult: ClassificationResponse?
    
    @Published var shownNewUserInfoView: Bool = false
    @Published var testStatus: TransferStatus?
    @Published var gotResults: Bool = false
    var receivedData = Data()
    var loggedIn: Bool {
        currentUser != nil
    }
    
    var database: Database
    init(database: Database) {
        self.database = database
        super.init()
//        loadData()
    }
    
    func login(username: String) {
        if username == "" {
            return
        }
        currentUser = ParticipantDao(database: database).get(username: username)
        if currentUser == nil {
            shownNewUserInfoView = true
        } else {
            shownNewUserInfoView = false
        }
        if let existedUser = currentUser{
            Report.query(on: database)
                .filter(\.$participantId.$id == existedUser.id!)
                .all()
                .whenComplete { result in
                    switch result {
                    case .success(let reports):
                        DispatchQueue.main.async {
                            self.reports = reports
                        }
                    case .failure(let error):
                        print("Error querying participants: \(error)")
                    }
                }
        }
    }
    
    func logout() {
        currentUser = nil
    }
//    clean the state
    func reset() {
        newReport = nil
        newLeftResult = nil
        newRightResult = nil
        print("reset")
        gotResults = false
    }
//    load reports from database and store it in the memory
    private func loadData() {
        Report.query(on: database)
            .all().whenComplete { result in
                switch result {
                case .success(let reports):
                    self.reports = reports
                case .failure(let error):
                    print("Error querying participants: \(error)")
                }
            }
    }
    
    func getReportCompletness(reportId: UUID) -> Bool {
        return false
    }
    
    func startTest(chooseRight: Bool, reportId: UUID?) {
        if !loggedIn {
            print("Please login first.")
            return
        }
        
        testStatus = .WaitingData
//        if let reportId = reportId {
//            //  assign to old report
//        } else {
//            // start a new report
//        }
    }
//    classify using local ml model
    func localClassify() -> ClassificationResponse {
        let model = PredictModel()
        let randomExample = Setting.examples.randomElement()!
        let (z,_,a) = model.predict(tpp:randomExample["tpp"]!,ecv:randomExample["ecv"]!,sa:randomExample["sa"]!,zeta:randomExample["zeta"]!,slope:randomExample["slope"]!)
        let (pressure, compliance) = simTracing(tpp:randomExample["tpp"]!,ecv:randomExample["ecv"]!,sa:randomExample["sa"]!,zeta:randomExample["zeta"]!,slope:randomExample["slope"]!)
        let newResponse = ClassificationResponse(tympType: a, ECV: z[0], TPP: z[1], ECV_std: z[2], TPP_std: z[3], pressure: pressure, compliance: compliance)
        return newResponse
    }
    //    classify using remote ml model
//    sending http request to backend server
    func remoteClassify(completion: @escaping (ClassificationResponse?) -> Void)  {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let urlStr = Setting.endpoint
        guard let url = URL(string: urlStr) else {
            //                throw MyError.runtimeError("cannot find url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let randomExample = Setting.examples.randomElement()!
        
        do {
            let randomExampleJson = try JSONEncoder().encode(randomExample)
            request.httpBody = randomExampleJson
            
        } catch {
            print(error)
            return
            
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            
            if let responseData = data {
                do {
                    let responseObj = try JSONDecoder().decode(ClassificationResponse.self, from: responseData)
                    completion(responseObj)
                } catch {
                    print("Error decoding response: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
//    classify for both local and remote cases
    func classify(local: Bool, isRight: Bool, completion: @escaping (Bool) -> Void) {
        if local {
            let newReponse = localClassify()
            self.gotResults = true
            if (!isRight) {
                self.newLeftResult = newReponse
            } else {
                self.newRightResult = newReponse
            }
            completion(true)
        } else {
            remoteClassify { responseObj in
                guard let _ = responseObj else {
                    print("Failed to get or parse the response.")
                    completion(false)
                    return
                }
                self.gotResults = true
                if (!isRight) {
                    self.newLeftResult = responseObj
                } else {
                    self.newRightResult = responseObj
                }
                completion(true)
            }
        }
    }
//    delete report from both memory and database
    func deleteReport(report: Report, completion: @escaping (Result<Void, Error>) -> Void) {
        let deleteFuture = report.delete(on: database)

        deleteFuture.whenComplete { result in
            switch result {
            case .success:
                // Update the reports array
                DispatchQueue.main.async {
                    self.reports = self.reports.filter { $0.id != report.id }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
// update participant in database and memory
//  currently only used to use participant's profile image
    func updatePerson(person:Participant, completion: @escaping (Result<Void, Error>) -> Void) {
        let updateFuture = person.save(on: database)
        updateFuture.whenComplete { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
