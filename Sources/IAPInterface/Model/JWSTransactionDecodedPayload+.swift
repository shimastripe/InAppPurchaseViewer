//
//  JWSTransactionDecodedPayload+.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import AppStoreServerLibrary  // For Model

public typealias JWSTransactionDecodedPayload = AppStoreServerLibrary.JWSTransactionDecodedPayload

public typealias JWSTransactionDecodedPayload = AppStoreServerLibrary.JWSTransactionDecodedPayload

extension JWSTransactionDecodedPayload: @retroactive Identifiable {
    public var id: String? {
        transactionId
    }
}
