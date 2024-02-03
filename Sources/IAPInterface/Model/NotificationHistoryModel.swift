//
//  NotificationHistoryModel.swift
//
//
//  Created by shimastripe on 2024/02/10.
//

import AppStoreServerLibrary  // For Model
import Foundation

public struct NotificationHistoryModel: Codable, Hashable {

    public var paginationToken: String?

    public var hasMore: Bool?

    public var items: [NotificationHistoryItem]

    public init(
        paginationToken: String?, hasMore: Bool?, items: [NotificationHistoryItem]
    ) {
        self.paginationToken = paginationToken
        self.hasMore = hasMore
        self.items = items
    }
}

public struct NotificationHistoryItem: Identifiable, Codable, Hashable {

    public struct ID: RawRepresentable, Hashable, Sendable, Codable, ExpressibleByStringLiteral {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            self = Self(rawValue: value)
        }
    }

    public let id: ID
    public let notificationType: NotificationTypeV2?
    public let subType: Subtype?
    public let signedDate: Date?

    // MARK: - Transaction
    public let transactionInfo: JWSTransactionDecodedPayload?
    // MARK: - RenewalInfo
    public let renewalInfo: JWSRenewalInfoDecodedPayload?

    public init?(
        _ payload: ResponseBodyV2DecodedPayload,
        transactionInfo: JWSTransactionDecodedPayload?,
        renewalInfo: JWSRenewalInfoDecodedPayload?
    ) {
        guard let notificationUUID = payload.notificationUUID else { return nil }
        self.id = .init(stringLiteral: notificationUUID)
        self.notificationType = payload.notificationType
        self.subType = payload.subtype
        self.signedDate = payload.signedDate
        self.transactionInfo = transactionInfo
        self.renewalInfo = renewalInfo
    }
}
