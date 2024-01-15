//
//  File.swift
//  mlDiagnostic
//
//  Created by Hunter Shen on 12/6/23.
//

import Foundation
enum MyError: Error, Identifiable {
    case deletionError
    case classificationError
    case updateError

    var id: String { self.localizedDescription }
    var localizedDescription: String {
        switch self {
        case .deletionError:
            return "Unable to delete the report."
        case.classificationError:
            return "Classification failed, please try again"
        case.updateError:
            return "Unable to update image, please try again"
        }
        }
        
   
    }

