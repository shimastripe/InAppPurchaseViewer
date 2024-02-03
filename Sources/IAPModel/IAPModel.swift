//
//  IAPModel.swift
//
//
//  Created by shimastripe on 2024/02/03.
//

import Dependencies
import Foundation
import IAPInterface
import Observation

@Observable
public final class IAPModel {

    // MARK: - State model

    public private(set) var rootCertificateState: LoadingViewState<Data> = .waiting

    public private(set) var credentialState: LoadingViewState<IAPEnvironment> = .waiting

    public private(set) var removeState: LoadingViewState<Int> = .waiting

    public private(set) var fetchNotificationHistoryState:
        LoadingViewState<NotificationHistoryModel> = .waiting

    public private(set) var fetchTransactionHistoryState: LoadingViewState<TransactionHistory> =
        .waiting

    public private(set) var fetchAllSubscriptionStatusesState:
        LoadingViewState<SubscriptionStatus> = .waiting

    // MARK: - Shared State parameters
    public var transactionID = ""
    public var environment: ServerEnvironment = .sandbox

    // MARK: - Notification History parameters
    public var notificationHistoryTransactionID = ""
    public var notificationStartDate = Calendar.current.date(
        byAdding: .weekOfMonth, value: -2, to: .now)!
    public var notificationEndDate = Date.now

    // MARK: - Transaction History parameters
    public var transactionStartDate = Calendar.current.date(
        byAdding: .year, value: -2, to: .now)!
    public var transactionEndDate = Date.now

    public init() {}

    public var isSetupLevel: Float {
        switch true {
        case credentialState.value != nil && rootCertificateState.value != nil: 1.0
        case credentialState.value != nil || rootCertificateState.value != nil: 0.5
        default: 0
        }
    }
    public var isCredentialEditing: Bool {
        credentialState.value == nil
    }
}

// MARK: - Action

extension IAPModel {

    public enum Action {
        case getRootCertificate
        case fetchRootCertificate

        case getCredential
        case saveCredential(
            bundleID: String, issuerID: String, keyID: String, appAppleID: Int,
            privateKeyFileURL: URL)

        case removeAll

        case fetchNotificationHistory(startDate: Date, endDate: Date, transactionID: String)
        case appendFetchNotificationHistory(startDate: Date, endDate: Date, transactionID: String)
        case bulkAppendFetchNotificationHistory(
            startDate: Date, endDate: Date, transactionID: String)
        case clearNotificationHistoryError

        case fetchTransactionHistory(startDate: Date, endDate: Date, transactionID: String)
        case appendFetchTransactionHistory(startDate: Date, endDate: Date, transactionID: String)
        case bulkAppendFetchTransactionHistory(
            startDate: Date, endDate: Date, transactionID: String)
        case clearTransactionHistoryError

        case fetchAllSubscriptionStatuses(transactionID: String)
        case clearAllSubscriptionStatusesError
    }

    @MainActor
    public func execute(action: Action) async {
        @Dependency(RootCertificateClient.self)
        var rootCertificateClient
        @Dependency(CredentialClient.self)
        var credentialClient
        @Dependency(AppStoreServerClient.self)
        var appStoreServerClient

        switch action {
        case .getRootCertificate:
            guard !rootCertificateState.isLoading else { return }
            rootCertificateState.startLoading()
            do {
                if let data = try await rootCertificateClient.get() {
                    rootCertificateState.finishLoading(data)
                } else {
                    rootCertificateState.clear()
                }
            } catch {
                rootCertificateState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }
        case .fetchRootCertificate:
            guard !rootCertificateState.isLoading else { return }
            rootCertificateState.startLoading()
            do {
                let data = try await rootCertificateClient.fetch()
                try await Task.sleep(for: .milliseconds(500))  // For transition
                rootCertificateState.finishLoading(data)
            } catch {
                rootCertificateState.failLoading(
                    with: .unknownError(message: error.localizedDescription))
            }

        case .getCredential:
            guard !credentialState.isLoading else { return }
            credentialState.startLoading()
            do {
                try await Task.sleep(for: .seconds(0.2))  // avoid blink for UX
                guard let savedCredential = try await credentialClient.get() else {
                    credentialState.clear()
                    return
                }
                credentialState.finishLoading(savedCredential)
            } catch {
                credentialState.failLoading(
                    with: .unknownError(message: error.localizedDescription))
            }

        case .saveCredential(
            let bundleID, let issuerID, let keyID, let appAppleID, let privateKeyFileURL):
            guard !credentialState.isLoading else { return }
            credentialState.startLoading()
            do {
                try await credentialClient.set(
                    bundleID: bundleID, issuerID: issuerID, keyID: keyID, appAppleID: appAppleID,
                    privateKeyFileURL: privateKeyFileURL)
                guard let savedCredential = try await credentialClient.get() else {
                    credentialState.failLoading(with: .unexpectedMissingCredential)
                    return
                }
                credentialState.finishLoading(savedCredential)
            } catch {
                credentialState.failLoading(
                    with: .unknownError(message: error.localizedDescription))
            }
        case .removeAll:
            guard !removeState.isLoading else { return }
            do {
                removeState.startLoading()

                try await credentialClient.remove()
                credentialState.clear()

                try await rootCertificateClient.remove()
                rootCertificateState.clear()

                removeState.clear()
            } catch {
                removeState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .fetchNotificationHistory(let startDate, let endDate, let transactionID):
            guard !fetchNotificationHistoryState.isLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value
            else { return }
            do {
                fetchNotificationHistoryState.startLoading()

                let id = transactionID.isEmpty ? nil : transactionID

                let model = try await appStoreServerClient.fetchNotificationHistory(
                    startDate: startDate, endDate: endDate, transactionID: id, paginationToken: nil,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment)
                fetchNotificationHistoryState.finishLoading(model)
            } catch {
                fetchNotificationHistoryState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .appendFetchNotificationHistory(let startDate, let endDate, let transactionID):
            guard !fetchNotificationHistoryState.isAppendLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let notificationHistory = fetchNotificationHistoryState.value
            else { return }
            do {
                fetchNotificationHistoryState.startAppendLoading()

                let id = transactionID.isEmpty ? nil : transactionID

                let model = try await appStoreServerClient.fetchNotificationHistory(
                    startDate: startDate, endDate: endDate, transactionID: id,
                    paginationToken: notificationHistory.paginationToken, credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment)
                let appendModel = NotificationHistoryModel(
                    paginationToken: model.paginationToken, hasMore: model.hasMore,
                    items: notificationHistory.items + model.items)
                fetchNotificationHistoryState.finishAppendLoading(appendModel)
            } catch {
                fetchNotificationHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .bulkAppendFetchNotificationHistory(let startDate, let endDate, let transactionID):
            guard !fetchNotificationHistoryState.isAppendLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let notificationHistory = fetchNotificationHistoryState.value
            else { return }
            do {
                fetchNotificationHistoryState.startAppendLoading()

                var merged = notificationHistory

                while true {
                    guard let hasMore = merged.hasMore, hasMore,
                        let paginationToken = merged.paginationToken
                    else {
                        break
                    }

                    let id = transactionID.isEmpty ? nil : transactionID

                    let model = try await appStoreServerClient.fetchNotificationHistory(
                        startDate: startDate, endDate: endDate, transactionID: id,
                        paginationToken: paginationToken, credential: credential,
                        rootCertificate: rootCertificate,
                        environment: environment)

                    merged = NotificationHistoryModel(
                        paginationToken: model.paginationToken, hasMore: model.hasMore,
                        items: merged.items + model.items)
                }

                fetchNotificationHistoryState.finishAppendLoading(merged)
            } catch {
                fetchNotificationHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .clearNotificationHistoryError:
            fetchNotificationHistoryState.clear()

        case .fetchTransactionHistory(let startDate, let endDate, let transactionID):
            guard !fetchTransactionHistoryState.isLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value
            else { return }
            do {
                fetchTransactionHistoryState.startLoading()

                let model = try await appStoreServerClient.fetchTransactionHistory(
                    startDate: startDate, endDate: endDate, transactionID: transactionID,
                    revision: nil,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment)
                fetchTransactionHistoryState.finishLoading(model)
            } catch {
                fetchTransactionHistoryState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .appendFetchTransactionHistory(let startDate, let endDate, let transactionID):
            guard !fetchTransactionHistoryState.isAppendLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let transactionHistory = fetchTransactionHistoryState.value
            else { return }
            do {
                fetchTransactionHistoryState.startAppendLoading()

                let model = try await appStoreServerClient.fetchTransactionHistory(
                    startDate: startDate, endDate: endDate, transactionID: transactionID,
                    revision: transactionHistory.revision, credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment)
                let appendModel = TransactionHistory(
                    revision: model.revision, hasMore: model.hasMore, bundleId: model.bundleId,
                    appAppleId: model.appAppleId, environment: model.environment,
                    items: transactionHistory.items + model.items)
                fetchTransactionHistoryState.finishAppendLoading(appendModel)
            } catch {
                fetchTransactionHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .bulkAppendFetchTransactionHistory(let startDate, let endDate, let transactionID):
            guard !fetchTransactionHistoryState.isAppendLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let transactionHistory = fetchTransactionHistoryState.value
            else { return }
            do {
                fetchTransactionHistoryState.startAppendLoading()

                var merged = transactionHistory

                while true {
                    guard let hasMore = merged.hasMore, hasMore,
                        let revision = merged.revision
                    else {
                        break
                    }

                    let model = try await appStoreServerClient.fetchTransactionHistory(
                        startDate: startDate, endDate: endDate, transactionID: transactionID,
                        revision: revision, credential: credential,
                        rootCertificate: rootCertificate,
                        environment: environment)

                    merged = .init(
                        revision: model.revision, hasMore: model.hasMore, bundleId: model.bundleId,
                        appAppleId: model.appAppleId, environment: model.environment,
                        items: merged.items + model.items)
                }

                fetchTransactionHistoryState.finishAppendLoading(merged)
            } catch {
                fetchTransactionHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .clearTransactionHistoryError:
            fetchTransactionHistoryState.clear()

        case .fetchAllSubscriptionStatuses(let transactionID):
            guard !fetchAllSubscriptionStatusesState.isAppendLoading,
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value
            else { return }
            do {
                fetchAllSubscriptionStatusesState.startLoading()

                let model = try await appStoreServerClient.fetchAllSubscriptionStatuses(
                    transactionID: transactionID, credential: credential,
                    rootCertificate: rootCertificate, environment: environment)
                fetchAllSubscriptionStatusesState.finishLoading(model)
            } catch {
                fetchAllSubscriptionStatusesState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
            }

        case .clearAllSubscriptionStatusesError:
            fetchAllSubscriptionStatusesState.clear()
        }
    }
}
