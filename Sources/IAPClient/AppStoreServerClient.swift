//
//  AppStoreServerClient.swift
//
//
//  Created by shimastripe on 2024/02/07.
//

import AppStoreServerLibrary
import Dependencies
import Foundation
import IAPInterface

extension AppStoreServerClient: DependencyKey {
    public static let liveValue: AppStoreServerClient = {
        .init(
            fetchNotificationHistory: {
                request, paginationToken, credential, rootCertificate,
                environment in

                let client = try AppStoreServerAPIClient(
                    signingKey: credential.encodedKey, keyId: credential.keyID,
                    issuerId: credential.issuerID, bundleId: credential.bundleID,
                    environment: environment.toModel)

                let signedDataVerifier = try SignedDataVerifier(
                    rootCertificates: [rootCertificate],
                    bundleId: credential.bundleID,
                    appAppleId: Int64(credential.appAppleID),
                    environment: environment.toModel,
                    enableOnlineChecks: false
                )

                let response = await client.getNotificationHistory(
                    paginationToken: paginationToken,
                    notificationHistoryRequest: request)

                switch response {
                case .success(let response):

                    guard
                        let signedPayloads = response.notificationHistory?.compactMap({
                            $0.signedPayload
                        })
                    else {
                        return .init(
                            paginationToken: response.paginationToken, hasMore: response.hasMore,
                            items: [])
                    }

                    var items: [NotificationHistoryItem] = []

                    for signedPayload in signedPayloads {
                        let decodedPayload =
                            try await signedDataVerifier.verifyAndDecodeNotification(
                                signedPayload)

                        var transactionInfo: JWSTransactionDecodedPayload?
                        if let signedTransactionInfo = decodedPayload.data?.signedTransactionInfo {
                            transactionInfo =
                                try await signedDataVerifier.verifyAndDecodeTransaction(
                                    signedTransactionInfo)
                        }

                        var renewalInfo: JWSRenewalInfoDecodedPayload?
                        if let signedRenewalInfo = decodedPayload.data?.signedRenewalInfo {
                            renewalInfo = try await signedDataVerifier.verifyAndDecodeRenewalInfo(
                                signedRenewalInfo)
                        }

                        let item = NotificationHistoryItem(
                            decodedPayload, transactionInfo: transactionInfo,
                            renewalInfo: renewalInfo)
                        guard let item else { continue }
                        items.append(item)
                    }

                    return .init(
                        paginationToken: response.paginationToken,
                        hasMore: response.hasMore,
                        items: items
                    )
                case .failure(
                    let statusCode, let rawApiError, _, let errorMessage, let causedBy):
                    throw AppStoreServerClientError.requestError(
                        statusCode: statusCode, rawApiError: rawApiError,
                        errorMessage: errorMessage,
                        causedBy: causedBy)
                }
            },
            fetchTransactionHistory: {
                startDate, endDate, transactionID, revision, credential, rootCertificate,
                environment in

                let client = try AppStoreServerAPIClient(
                    signingKey: credential.encodedKey, keyId: credential.keyID,
                    issuerId: credential.issuerID, bundleId: credential.bundleID,
                    environment: environment.toModel)

                let signedDataVerifier = try SignedDataVerifier(
                    rootCertificates: [rootCertificate],
                    bundleId: credential.bundleID,
                    appAppleId: Int64(credential.appAppleID),
                    environment: environment.toModel,
                    enableOnlineChecks: false
                )

                let response = await client.getTransactionHistory(
                    transactionId: transactionID, revision: revision,
                    transactionHistoryRequest: .init(startDate: startDate, endDate: endDate),
                    version: .v2
                )

                switch response {
                case .success(let response):

                    guard
                        let signedTransactions = response.signedTransactions
                    else {
                        throw AppStoreServerClientError.unknownAPIError(
                            message: "No signed transactions")
                    }

                    var items: [JWSTransactionDecodedPayload] = []

                    for signedTransaction in signedTransactions {
                        items.append(
                            try await signedDataVerifier.verifyAndDecodeTransaction(
                                signedTransaction))
                    }

                    items = items.sorted(by: {
                        ($0.purchaseDate ?? .distantPast) < ($1.purchaseDate ?? .distantPast)
                    })

                    return .init(
                        revision: response.revision, hasMore: response.hasMore,
                        bundleId: response.bundleId, appAppleId: response.appAppleId,
                        environment: response.environment, items: items)
                case .failure(
                    let statusCode, let rawApiError, _, let errorMessage, let causedBy):
                    throw AppStoreServerClientError.requestError(
                        statusCode: statusCode, rawApiError: rawApiError,
                        errorMessage: errorMessage,
                        causedBy: causedBy)
                }
            },
            fetchAllSubscriptionStatuses: {
                transactionID, credential, rootCertificate,
                environment in
                let client = try AppStoreServerAPIClient(
                    signingKey: credential.encodedKey, keyId: credential.keyID,
                    issuerId: credential.issuerID, bundleId: credential.bundleID,
                    environment: environment.toModel)

                let signedDataVerifier = try SignedDataVerifier(
                    rootCertificates: [rootCertificate],
                    bundleId: credential.bundleID,
                    appAppleId: Int64(credential.appAppleID),
                    environment: environment.toModel,
                    enableOnlineChecks: false
                )

                let response = await client.getAllSubscriptionStatuses(
                    transactionId: transactionID, status: nil)

                switch response {
                case .success(let response):
                    var items: [SubscriptionGroup] = []

                    for data in (response.data ?? []) {
                        var transactions: [LastTransaction] = []

                        let lastTransactions = data.lastTransactions ?? []

                        for lastTransaction in lastTransactions {

                            var transactionInfo: JWSTransactionDecodedPayload?
                            if let signedTransactionInfo = lastTransaction.signedTransactionInfo {
                                transactionInfo =
                                    try await signedDataVerifier.verifyAndDecodeTransaction(
                                        signedTransactionInfo)
                            }

                            var renewalInfo: JWSRenewalInfoDecodedPayload?
                            if let signedRenewalInfo = lastTransaction.signedRenewalInfo {
                                renewalInfo =
                                    try await signedDataVerifier.verifyAndDecodeRenewalInfo(
                                        signedRenewalInfo)
                            }

                            transactions.append(
                                .init(
                                    status: lastTransaction.status,
                                    originalTransactionId: lastTransaction.originalTransactionId,
                                    transaction: transactionInfo, renewalInfo: renewalInfo))
                        }

                        items.append(
                            .init(
                                subscriptionGroupIdentifier: data.subscriptionGroupIdentifier,
                                items: transactions))
                    }

                    return .init(
                        environment: response.environment, bundleID: response.bundleId,
                        appAppleID: response.appAppleId, items: items)
                case .failure(let statusCode, let rawApiError, _, let errorMessage, let causedBy):
                    throw AppStoreServerClientError.requestError(
                        statusCode: statusCode, rawApiError: rawApiError,
                        errorMessage: errorMessage,
                        causedBy: causedBy)
                }
            })
    }()
}
