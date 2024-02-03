//
//  IAPError.swift
//
//
//  Created by shimastripe on 2024/02/05.
//

import Foundation

public enum IAPError: LocalizedError, Equatable {
    case noSignedTransactions
    case requestError(message: String?)
    case unknownError(message: String?)
    case unexpectedMissingCredential

    public var errorDescription: String? {
        switch self {
        case .noSignedTransactions:
            "noSignedTransactions"
        case .requestError(let message):
            "requestError: \(message ?? "")"
        case .unknownError(let message):
            "unknownError: \(message ?? "")"
        case .unexpectedMissingCredential:
            "unexpectedMissingCredential"
        }
    }
}
