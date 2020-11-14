//
//  FBFirestoreError.swift
//  I2WE
//
//  Created by Jaden Kim on 11/7/20.
//

import Foundation

enum FirestoreError: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
}

extension FirestoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noAuthDataResult:
            return NSLocalizedString("No auth data result", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No current user", comment: "")
        case .noDocumentSnapshot:
            return NSLocalizedString("No document snapshot", comment: "")
        case .noSnapshotData:
            return NSLocalizedString("No snapshot data", comment: "")
        case .noUser:
            return NSLocalizedString("No user", comment: "")
        }
    }
}
