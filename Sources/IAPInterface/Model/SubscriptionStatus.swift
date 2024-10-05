//
//  SubscriptionStatus.swift
//
//
//  Created by shimastripe on 2024/02/22.
//

import AppStoreServerLibrary  // For Model
import Foundation

public struct SubscriptionStatus: Codable, Hashable, Sendable {

    public let environment: Environment?

    public let bundleID: String?

    public let appAppleID: Int64?

    public let items: [SubscriptionGroup]

    public init(
        environment: Environment?, bundleID: String?, appAppleID: Int64?, items: [SubscriptionGroup]
    ) {
        self.environment = environment
        self.bundleID = bundleID
        self.appAppleID = appAppleID
        self.items = items
    }
}

public struct SubscriptionGroup: Codable, Hashable, Identifiable, Sendable {

    public let subscriptionGroupIdentifier: String?

    public let items: [LastTransaction]

    public init(
        subscriptionGroupIdentifier: String?,
        items: [LastTransaction]
    ) {
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.items = items
    }

    public var id: String? {
        subscriptionGroupIdentifier
    }
}

public struct LastTransaction: Codable, Hashable, Identifiable, Sendable {

    public let status: Status?

    public let originalTransactionId: String?

    // MARK: - Transaction
    public let transaction: JWSTransactionDecodedPayload?

    // MARK: - RenewalInfo
    public let renewalInfo: JWSRenewalInfoDecodedPayload?

    public init(
        status: Status?, originalTransactionId: String?, transaction: JWSTransactionDecodedPayload?,
        renewalInfo: JWSRenewalInfoDecodedPayload?
    ) {
        self.status = status
        self.originalTransactionId = originalTransactionId
        self.transaction = transaction
        self.renewalInfo = renewalInfo
    }

    public var id: String? {
        originalTransactionId
    }
}
