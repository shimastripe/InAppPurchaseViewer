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
public struct AppStoreServerClient {

    public enum AppStoreServerClientError: LocalizedError {
        case requestError(
            statusCode: Int?, rawApiError: Int64?, errorMessage: String?, causedBy: Error?)
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
        (
            _ startDate: Date, _ endDate: Date, _ transactionID: String?,
            _ paginationToken: String?,
            _ credential: IAPEnvironment, _ rootCertificate: Data, _ environment: ServerEnvironment
        )
            async throws -> NotificationHistoryModel

    public var fetchTransactionHistory:
        (
            _ startDate: Date, _ endDate: Date, _ transactionID: String,
            _ revision: String?, _ credential: IAPEnvironment, _ rootCertificate: Data,
            _ environment: ServerEnvironment
        ) async throws -> TransactionHistory

    public var fetchAllSubscriptionStatuses:
        (
            _ transactionID: String, _ credential: IAPEnvironment, _ rootCertificate: Data,
            _ environment: ServerEnvironment
        ) async throws -> SubscriptionStatus
}

// MARK: Implementation

extension AppStoreServerClient: TestDependencyKey {
    public static var testValue = Self()
}
