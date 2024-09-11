//
//  AppStoreServerClientInterface.swift
//
//
//  Created by shimastripe on 2024/02/07.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AppStoreServerClient: Sendable {

    public enum AppStoreServerClientError: LocalizedError {
        case requestError(
            statusCode: Int?, rawApiError: Int64?, errorMessage: String?, causedBy: (any Error)?)
        case unknownAPIError(message: String?)

        public var errorDescription: String? {
            switch self {
            case .requestError(let statusCode, let rawApiError, let errorMessage, let causedBy):
                "request error: statusCode: \(statusCode.map(\.description) ?? "nil"), rawApiError: \(rawApiError.map(\.description) ?? "nil"), errorMessage: \(errorMessage ?? "nil"), causedBy: \(causedBy?.localizedDescription ?? "nil")"
            case .unknownAPIError(let message):
                message
            }
        }
    }

    public var fetchNotificationHistory:
        @Sendable
        (
            _ startDate: Date, _ endDate: Date, _ transactionID: String?,
            _ paginationToken: String?,
            _ credential: IAPEnvironment, _ rootCertificate: Data, _ environment: ServerEnvironment
        )
            async throws -> NotificationHistoryModel

    public var fetchTransactionHistory:
        @Sendable
        (
            _ startDate: Date, _ endDate: Date, _ transactionID: String,
            _ revision: String?, _ credential: IAPEnvironment, _ rootCertificate: Data,
            _ environment: ServerEnvironment
        ) async throws -> TransactionHistory

    public var fetchAllSubscriptionStatuses:
        @Sendable
        (
            _ transactionID: String, _ credential: IAPEnvironment, _ rootCertificate: Data,
            _ environment: ServerEnvironment
        ) async throws -> SubscriptionStatus
}

// MARK: Implementation
extension AppStoreServerClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue: AppStoreServerClient = {
        let makeDate:
            @Sendable (_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date? =
                {
                    (year, month, day, hour, minute) in
                    Calendar.current.date(
                        from: .init(
                            year: year, month: month, day: day, hour: hour, minute: minute))
                }

        return .init(
            fetchNotificationHistory: { _, _, _, _, _, _, _ in
                NotificationHistoryModel(
                    paginationToken: "paginationToken", hasMore: true,
                    items: [
                        .init(
                            .init(
                                notificationType: .subscribed, subtype: .initialBuy,
                                notificationUUID: "1", data: nil, version: nil,
                                signedDate: makeDate(2024, 4, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000000",
                                purchaseDate: makeDate(2024, 4, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                expiresDate: makeDate(2024, 5, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 0), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .didRenew, subtype: nil, notificationUUID: "2",
                                data: nil, version: nil, signedDate: makeDate(2024, 5, 1, 9, 0),
                                summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000001",
                                purchaseDate: makeDate(2024, 5, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                expiresDate: makeDate(2024, 6, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .didFailToRenew, subtype: .gracePeriod,
                                notificationUUID: "3", data: nil, version: nil,
                                signedDate: makeDate(2024, 6, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000001",
                                purchaseDate: makeDate(2024, 5, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                expiresDate: makeDate(2024, 6, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .gracePeriodExpired, subtype: nil,
                                notificationUUID: "4", data: nil, version: nil,
                                signedDate: makeDate(2024, 6, 17, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000001",
                                purchaseDate: makeDate(2024, 5, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                expiresDate: makeDate(2024, 6, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .expired, subtype: .billingRetry,
                                notificationUUID: "5", data: nil, version: nil,
                                signedDate: makeDate(2024, 7, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000001",
                                purchaseDate: makeDate(2024, 5, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                expiresDate: makeDate(2024, 6, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .subscribed, subtype: .initialBuy,
                                notificationUUID: "6", data: nil, version: nil,
                                signedDate: makeDate(2024, 8, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "2000000000000000",
                                transactionId: "2000000000000000",
                                purchaseDate: makeDate(2024, 8, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 8, 1, 9, 0),
                                expiresDate: makeDate(2024, 9, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 0), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .didRenew, subtype: nil,
                                notificationUUID: "7", data: nil, version: nil,
                                signedDate: makeDate(2024, 9, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "2000000000000000",
                                transactionId: "2000000000000001",
                                purchaseDate: makeDate(2024, 9, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 8, 1, 9, 0),
                                expiresDate: makeDate(2024, 10, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .subscribed, subtype: .resubscribe,
                                notificationUUID: "8", data: nil, version: nil,
                                signedDate: makeDate(2024, 9, 1, 15, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000002",
                                purchaseDate: makeDate(2024, 9, 1, 15, 0),
                                originalPurchaseDate: makeDate(2024, 9, 1, 15, 0),
                                expiresDate: makeDate(2024, 10, 1, 15, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .didRenew, subtype: nil,
                                notificationUUID: "9", data: nil, version: nil,
                                signedDate: makeDate(2024, 10, 1, 9, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "2000000000000000",
                                transactionId: "2000000000000001",
                                purchaseDate: makeDate(2024, 10, 1, 9, 0),
                                originalPurchaseDate: makeDate(2024, 8, 1, 9, 0),
                                expiresDate: makeDate(2024, 11, 1, 9, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                        .init(
                            .init(
                                notificationType: .didRenew, subtype: nil,
                                notificationUUID: "10", data: nil, version: nil,
                                signedDate: makeDate(2024, 10, 1, 15, 0), summary: nil),
                            transactionInfo: .init(
                                originalTransactionId: "1000000000000000",
                                transactionId: "1000000000000003",
                                purchaseDate: makeDate(2024, 10, 1, 15, 0),
                                originalPurchaseDate: makeDate(2024, 9, 1, 15, 0),
                                expiresDate: makeDate(2024, 11, 1, 15, 0), environment: .sandbox,
                                currency: "JPY", price: 500000), renewalInfo: nil)!,
                    ])
            },
            fetchTransactionHistory: { _, _, _, _, _, _, _ in
                TransactionHistory(
                    revision: "revision", hasMore: true, bundleId: nil, appAppleId: nil,
                    environment: .sandbox,
                    items: [
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000000",
                            purchaseDate: makeDate(2024, 4, 1, 9, 0),
                            originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                            expiresDate: makeDate(2024, 5, 1, 9, 0), offerType: .introductoryOffer,
                            environment: .sandbox, transactionReason: .purchase, currency: "JPY",
                            price: 0, offerDiscountType: .freeTrial),
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000001",
                            purchaseDate: makeDate(2024, 5, 1, 9, 0),
                            originalPurchaseDate: makeDate(2024, 5, 1, 9, 0),
                            expiresDate: makeDate(2024, 6, 1, 9, 0),
                            environment: .sandbox, transactionReason: .renewal, currency: "JPY",
                            price: 500000),
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000002",
                            purchaseDate: makeDate(2024, 6, 1, 9, 0),
                            originalPurchaseDate: makeDate(2024, 6, 1, 9, 0),
                            expiresDate: makeDate(2024, 7, 1, 9, 0),
                            environment: .sandbox, transactionReason: .renewal, currency: "JPY",
                            price: 500000),
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000003",
                            purchaseDate: makeDate(2024, 7, 1, 9, 0),
                            originalPurchaseDate: makeDate(2024, 7, 1, 9, 0),
                            expiresDate: makeDate(2024, 8, 1, 9, 0),
                            environment: .sandbox, transactionReason: .renewal, currency: "JPY",
                            price: 500000),
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000004",
                            purchaseDate: makeDate(2024, 10, 1, 15, 0),
                            originalPurchaseDate: makeDate(2024, 10, 1, 15, 0),
                            expiresDate: makeDate(2024, 11, 1, 15, 0),
                            environment: .sandbox, transactionReason: .purchase, currency: "JPY",
                            price: 500000),
                        .init(
                            originalTransactionId: "1000000000000000",
                            transactionId: "1000000000000005",
                            purchaseDate: makeDate(2024, 12, 1, 9, 0),
                            originalPurchaseDate: makeDate(2024, 12, 1, 9, 0),
                            expiresDate: makeDate(2025, 1, 1, 9, 0),
                            environment: .sandbox, transactionReason: .purchase, currency: "JPY",
                            price: 500000),
                    ])
            },
            fetchAllSubscriptionStatuses: { _, _, _, _ in
                SubscriptionStatus(
                    environment: .sandbox, bundleID: nil, appAppleID: nil,
                    items: [
                        .init(
                            subscriptionGroupIdentifier: "11111111",
                            items: [
                                .init(
                                    status: .active, originalTransactionId: "1000000000000000",
                                    transaction: .init(
                                        originalTransactionId: "1000000000000000",
                                        transactionId: "1000000000000009",
                                        subscriptionGroupIdentifier: "1000000000000000",
                                        purchaseDate: makeDate(2024, 4, 1, 9, 0),
                                        originalPurchaseDate: makeDate(2024, 4, 1, 9, 0),
                                        expiresDate: makeDate(2024, 5, 1, 9, 0),
                                        environment: .sandbox, currency: "JPY", price: 500000),
                                    renewalInfo: nil)
                            ]),
                        .init(
                            subscriptionGroupIdentifier: "22222222",
                            items: [
                                .init(
                                    status: .billingGracePeriod,
                                    originalTransactionId: "2000000000000000",
                                    transaction: .init(
                                        originalTransactionId: "2000000000000000",
                                        transactionId: "2000000000000004",
                                        subscriptionGroupIdentifier: "2000000000000000",
                                        purchaseDate: makeDate(2024, 7, 1, 9, 0),
                                        originalPurchaseDate: makeDate(2024, 7, 1, 9, 0),
                                        expiresDate: makeDate(2024, 7, 15, 9, 0),
                                        environment: .sandbox, currency: "JPY", price: 980000),
                                    renewalInfo: nil)
                            ]),
                        .init(
                            subscriptionGroupIdentifier: "33333333",
                            items: [
                                .init(
                                    status: .expired, originalTransactionId: "3000000000000000",
                                    transaction: .init(
                                        originalTransactionId: "3000000000000000",
                                        transactionId: "3000000000000010",
                                        subscriptionGroupIdentifier: "3000000000000000",
                                        purchaseDate: makeDate(2024, 5, 1, 9, 0),
                                        originalPurchaseDate: makeDate(2024, 5, 1, 9, 0),
                                        expiresDate: makeDate(2024, 6, 1, 9, 0),
                                        environment: .sandbox, currency: "JPY", price: 700000),
                                    renewalInfo: nil)
                            ]),
                    ])
            })
    }()
}
