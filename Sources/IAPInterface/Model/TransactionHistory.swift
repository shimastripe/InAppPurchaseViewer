//
//  TransactionHistory.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import Foundation

public struct TransactionHistory: Codable, Hashable, Sendable {

    public var revision: String?

    public var hasMore: Bool?

    public var bundleId: String?

    public var appAppleId: Int64?

    public var environment: AppStoreEnvironment?

    // MARK: - Transaction
    public var items: [JWSTransactionDecodedPayload]

    public init(
        revision: String?, hasMore: Bool?, bundleId: String?, appAppleId: Int64?,
        environment: AppStoreEnvironment?, items: [JWSTransactionDecodedPayload]
    ) {
        self.revision = revision
        self.hasMore = hasMore
        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.environment = environment
        self.items = items
    }
}
