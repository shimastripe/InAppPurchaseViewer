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

    // MARK: - Dependency

    @ObservationIgnored
    @Dependency(\.calendar) var calendar

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
    /// whether highlighted retry button
    public var isStaledParameters = false
    public var transactionID = ""
    public var environment: ServerEnvironment = .sandbox

    // MARK: - Notification History parameters
    /// whether highlighted notification history retry button
    public var isNotificationHistoryStaledParameters = false
    public var notificationHistoryTransactionID = ""
    public var notificationStartDate = Date.distantPast
    public var notificationEndDate = Date.now
    public var notificationFilterOption: NotificationFilterOption? = nil
    public var onlyFailuresFilter: Bool? = nil

    // MARK: - Transaction History parameters
    public var transactionStartDate = Date.distantPast
    public var transactionEndDate = Date.now

    public init() {
        resetNotificationDates()
        resetTransactionDates()
    }

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

    public func resetNotificationDates() {
        notificationStartDate = Calendar.current.date(
            byAdding: .day, value: -1, to: .now)!
        notificationEndDate = Date.now
    }

    public func resetTransactionDates() {
        transactionStartDate = Calendar.current.date(
            byAdding: .year, value: -5, to: .now)!
        transactionEndDate = Date.now
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value
            else { return }
            do {
                fetchNotificationHistoryState.startLoading()

                // transactionId and notificationType are mutually exclusive in the API
                let id = transactionID.isEmpty ? nil : transactionID
                let filterOption = id == nil ? notificationFilterOption : nil
                let failuresFilter = id == nil ? onlyFailuresFilter : nil

                let request = NotificationHistoryRequest(
                    startDate: startDate, endDate: endDate,
                    notificationType: filterOption?.notificationType,
                    notificationSubtype: filterOption?.subtype,
                    transactionId: id, onlyFailures: failuresFilter)
                let model = try await appStoreServerClient.fetchNotificationHistory(
                    request: request, paginationToken: nil,
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let notificationHistory = fetchNotificationHistoryState.value
            else { return }
            do {
                fetchNotificationHistoryState.startAppendLoading()

                // transactionId and notificationType are mutually exclusive in the API
                let id = transactionID.isEmpty ? nil : transactionID
                let filterOption = id == nil ? notificationFilterOption : nil
                let failuresFilter = id == nil ? onlyFailuresFilter : nil

                let request = NotificationHistoryRequest(
                    startDate: startDate, endDate: endDate,
                    notificationType: filterOption?.notificationType,
                    notificationSubtype: filterOption?.subtype,
                    transactionId: id, onlyFailures: failuresFilter)
                let model = try await appStoreServerClient.fetchNotificationHistory(
                    request: request, paginationToken: notificationHistory.paginationToken,
                    credential: credential, rootCertificate: rootCertificate,
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let notificationHistory = fetchNotificationHistoryState.value
            else { return }
            do {
                fetchNotificationHistoryState.startAppendLoading()

                var merged = notificationHistory

                let loopCounts = 10

                for _ in 0 ..< loopCounts {
                    guard let hasMore = merged.hasMore, hasMore,
                        let paginationToken = merged.paginationToken
                    else {
                        break
                    }

                    // transactionId and notificationType are mutually exclusive in the API
                    let id = transactionID.isEmpty ? nil : transactionID
                    let filterOption = id == nil ? notificationFilterOption : nil
                    let failuresFilter = id == nil ? onlyFailuresFilter : nil

                    let request = NotificationHistoryRequest(
                        startDate: startDate, endDate: endDate,
                        notificationType: filterOption?.notificationType,
                        notificationSubtype: filterOption?.subtype,
                        transactionId: id, onlyFailures: failuresFilter)
                    let model = try await appStoreServerClient.fetchNotificationHistory(
                        request: request, paginationToken: paginationToken,
                        credential: credential,
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
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
                let startDate = truncateSeconds(of: startDate),
                let endDate = roundUpSeconds(of: endDate),
                let credential = credentialState.value,
                let rootCertificate = rootCertificateState.value,
                let transactionHistory = fetchTransactionHistoryState.value
            else { return }
            do {
                fetchTransactionHistoryState.startAppendLoading()

                var merged = transactionHistory

                let loopCounts = 10

                for _ in 0 ..< loopCounts {
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

// MARK: - Helper

extension IAPModel {

    func truncateSeconds(of date: Date) -> Date? {
        calendar.date(
            from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
    }

    func roundUpSeconds(of date: Date) -> Date? {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        if let minutes = components.minute {
            components.minute = minutes + 1
        }
        return calendar.date(from: components)
    }
}
