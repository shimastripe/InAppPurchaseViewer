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

    @ObservationIgnored
    private var fetchNotificationHistoryTask: Task<Void, Never>?

    @ObservationIgnored
    private var fetchNotificationHistoryGeneration = 0

    @ObservationIgnored
    private var fetchTransactionHistoryTask: Task<Void, Never>?

    @ObservationIgnored
    private var fetchTransactionHistoryGeneration = 0

    @ObservationIgnored
    private var fetchAllSubscriptionStatusesTask: Task<Void, Never>?

    @ObservationIgnored
    private var fetchAllSubscriptionStatusesGeneration = 0

    @ObservationIgnored
    private var fetchTransactionInfoTask: Task<Void, Never>?

    @ObservationIgnored
    private var fetchTransactionInfoGeneration = 0

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

    public private(set) var fetchTransactionInfoState:
        LoadingViewState<JWSTransactionDecodedPayload> = .waiting

    // MARK: - Shared State parameters
    /// whether highlighted retry button
    public var isStaledParameters = false
    public var transactionID = ""
    public var environment: ServerEnvironment = .production

    // MARK: - Transaction Info parameters
    public var isTransactionInfoStaledParameters = false
    public var transactionInfoTransactionID = ""

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
        case reloadNotificationHistory(startDate: Date, endDate: Date, transactionID: String)
        case appendFetchNotificationHistory(startDate: Date, endDate: Date, transactionID: String)
        case bulkAppendFetchNotificationHistory(
            startDate: Date, endDate: Date, transactionID: String)
        case clearNotificationHistoryError

        case fetchTransactionHistory(startDate: Date, endDate: Date, transactionID: String)
        case reloadTransactionHistory(startDate: Date, endDate: Date, transactionID: String)
        case appendFetchTransactionHistory(startDate: Date, endDate: Date, transactionID: String)
        case bulkAppendFetchTransactionHistory(
            startDate: Date, endDate: Date, transactionID: String)
        case clearTransactionHistoryError

        case fetchAllSubscriptionStatuses(transactionID: String)
        case reloadAllSubscriptionStatuses(transactionID: String)
        case clearAllSubscriptionStatusesError

        case fetchTransactionInfo(transactionID: String)
        case reloadTransactionInfo(transactionID: String)
        case clearTransactionInfoError
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
            guard !rootCertificateState.isLoadingOrAppending else { return }
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
            guard !rootCertificateState.isLoadingOrAppending else { return }
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
            guard !credentialState.isLoadingOrAppending else { return }
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
            guard !credentialState.isLoadingOrAppending else { return }
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
            guard !removeState.isLoadingOrAppending else { return }
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
            await fetchNotificationHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                replacesInFlightRequest: false,
                appStoreServerClient: appStoreServerClient
            )

        case .reloadNotificationHistory(let startDate, let endDate, let transactionID):
            await fetchNotificationHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                replacesInFlightRequest: true,
                appStoreServerClient: appStoreServerClient
            )

        case .appendFetchNotificationHistory(let startDate, let endDate, let transactionID):
            await appendFetchNotificationHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                loopCounts: 1,
                appStoreServerClient: appStoreServerClient
            )

        case .bulkAppendFetchNotificationHistory(let startDate, let endDate, let transactionID):
            await appendFetchNotificationHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                loopCounts: 10,
                appStoreServerClient: appStoreServerClient
            )

        case .clearNotificationHistoryError:
            fetchNotificationHistoryState.clearFailure()

        case .fetchTransactionHistory(let startDate, let endDate, let transactionID):
            await fetchTransactionHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                replacesInFlightRequest: false,
                appStoreServerClient: appStoreServerClient
            )

        case .reloadTransactionHistory(let startDate, let endDate, let transactionID):
            await fetchTransactionHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                replacesInFlightRequest: true,
                appStoreServerClient: appStoreServerClient
            )

        case .appendFetchTransactionHistory(let startDate, let endDate, let transactionID):
            await appendFetchTransactionHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                loopCounts: 1,
                appStoreServerClient: appStoreServerClient
            )

        case .bulkAppendFetchTransactionHistory(let startDate, let endDate, let transactionID):
            await appendFetchTransactionHistory(
                startDate: startDate,
                endDate: endDate,
                transactionID: transactionID,
                loopCounts: 10,
                appStoreServerClient: appStoreServerClient
            )

        case .clearTransactionHistoryError:
            fetchTransactionHistoryState.clearFailure()

        case .fetchAllSubscriptionStatuses(let transactionID):
            await fetchAllSubscriptionStatuses(
                transactionID: transactionID,
                replacesInFlightRequest: false,
                appStoreServerClient: appStoreServerClient
            )

        case .reloadAllSubscriptionStatuses(let transactionID):
            await fetchAllSubscriptionStatuses(
                transactionID: transactionID,
                replacesInFlightRequest: true,
                appStoreServerClient: appStoreServerClient
            )

        case .clearAllSubscriptionStatusesError:
            fetchAllSubscriptionStatusesState.clearFailure()

        case .fetchTransactionInfo(let transactionID):
            await fetchTransactionInfo(
                transactionID: transactionID,
                replacesInFlightRequest: false,
                appStoreServerClient: appStoreServerClient
            )

        case .reloadTransactionInfo(let transactionID):
            await fetchTransactionInfo(
                transactionID: transactionID,
                replacesInFlightRequest: true,
                appStoreServerClient: appStoreServerClient
            )

        case .clearTransactionInfoError:
            fetchTransactionInfoState.clearFailure()
        }
    }
}

// MARK: - Loading Tasks

extension IAPModel {

    @MainActor
    private func fetchNotificationHistory(
        startDate: Date,
        endDate: Date,
        transactionID: String,
        replacesInFlightRequest: Bool,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard replacesInFlightRequest || !fetchNotificationHistoryState.isLoadingOrAppending else {
            return
        }

        fetchNotificationHistoryGeneration += 1
        let generation = fetchNotificationHistoryGeneration

        fetchNotificationHistoryTask?.cancel()

        guard
            let startDate = truncateSeconds(of: startDate),
            let endDate = roundUpSeconds(of: endDate),
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value
        else {
            if replacesInFlightRequest {
                fetchNotificationHistoryState.clear()
            }
            fetchNotificationHistoryTask = nil
            return
        }

        fetchNotificationHistoryState.restartLoading()

        // transactionId and notificationType are mutually exclusive in the API
        let id = transactionID.isEmpty ? nil : transactionID
        let filterOption = id == nil ? notificationFilterOption : nil
        let failuresFilter = id == nil ? onlyFailuresFilter : nil
        let request = NotificationHistoryRequest(
            startDate: startDate,
            endDate: endDate,
            notificationType: filterOption?.notificationType,
            notificationSubtype: filterOption?.subtype,
            transactionId: id,
            onlyFailures: failuresFilter
        )
        let environment = environment

        let task = Task {
            @MainActor [appStoreServerClient, request, credential, rootCertificate, environment] in
            do {
                let model = try await appStoreServerClient.fetchNotificationHistory(
                    request: request,
                    paginationToken: nil,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment
                )
                try Task.checkCancellation()

                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.finishLoading(model)
                fetchNotificationHistoryTask = nil
            } catch is CancellationError {
                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.clear()
                fetchNotificationHistoryTask = nil
            } catch {
                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchNotificationHistoryTask = nil
            }
        }

        fetchNotificationHistoryTask = task
        await task.value
    }

    @MainActor
    private func appendFetchNotificationHistory(
        startDate: Date,
        endDate: Date,
        transactionID: String,
        loopCounts: Int,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard !fetchNotificationHistoryState.isLoadingOrAppending,
            let startDate = truncateSeconds(of: startDate),
            let endDate = roundUpSeconds(of: endDate),
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value,
            let notificationHistory = fetchNotificationHistoryState.value
        else { return }

        fetchNotificationHistoryGeneration += 1
        let generation = fetchNotificationHistoryGeneration

        fetchNotificationHistoryTask?.cancel()
        fetchNotificationHistoryState.startAppendLoading()

        // transactionId and notificationType are mutually exclusive in the API
        let id = transactionID.isEmpty ? nil : transactionID
        let filterOption = id == nil ? notificationFilterOption : nil
        let failuresFilter = id == nil ? onlyFailuresFilter : nil
        let request = NotificationHistoryRequest(
            startDate: startDate,
            endDate: endDate,
            notificationType: filterOption?.notificationType,
            notificationSubtype: filterOption?.subtype,
            transactionId: id,
            onlyFailures: failuresFilter
        )
        let environment = environment

        let task = Task {
            @MainActor [
                appStoreServerClient, request, credential, rootCertificate, environment,
                notificationHistory
            ] in
            do {
                var merged = notificationHistory

                for _ in 0 ..< loopCounts {
                    guard let hasMore = merged.hasMore, hasMore,
                        let paginationToken = merged.paginationToken
                    else {
                        break
                    }

                    let model = try await appStoreServerClient.fetchNotificationHistory(
                        request: request,
                        paginationToken: paginationToken,
                        credential: credential,
                        rootCertificate: rootCertificate,
                        environment: environment
                    )
                    try Task.checkCancellation()

                    merged = NotificationHistoryModel(
                        paginationToken: model.paginationToken,
                        hasMore: model.hasMore,
                        items: merged.items + model.items
                    )
                }

                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.finishAppendLoading(merged)
                fetchNotificationHistoryTask = nil
            } catch is CancellationError {
                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.finishAppendLoading(notificationHistory)
                fetchNotificationHistoryTask = nil
            } catch {
                guard generation == fetchNotificationHistoryGeneration else { return }
                fetchNotificationHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchNotificationHistoryTask = nil
            }
        }

        fetchNotificationHistoryTask = task
        await task.value
    }

    @MainActor
    private func fetchTransactionHistory(
        startDate: Date,
        endDate: Date,
        transactionID: String,
        replacesInFlightRequest: Bool,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard replacesInFlightRequest || !fetchTransactionHistoryState.isLoadingOrAppending else {
            return
        }

        fetchTransactionHistoryGeneration += 1
        let generation = fetchTransactionHistoryGeneration

        fetchTransactionHistoryTask?.cancel()

        guard !transactionID.isEmpty,
            let startDate = truncateSeconds(of: startDate),
            let endDate = roundUpSeconds(of: endDate),
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value
        else {
            if replacesInFlightRequest {
                fetchTransactionHistoryState.clear()
            }
            fetchTransactionHistoryTask = nil
            return
        }

        fetchTransactionHistoryState.restartLoading()

        let environment = environment
        let task = Task {
            @MainActor [
                appStoreServerClient, startDate, endDate, transactionID, credential,
                rootCertificate, environment
            ] in
            do {
                let model = try await appStoreServerClient.fetchTransactionHistory(
                    startDate: startDate,
                    endDate: endDate,
                    transactionID: transactionID,
                    revision: nil,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment
                )
                try Task.checkCancellation()

                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.finishLoading(model)
                fetchTransactionHistoryTask = nil
            } catch is CancellationError {
                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.clear()
                fetchTransactionHistoryTask = nil
            } catch {
                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchTransactionHistoryTask = nil
            }
        }

        fetchTransactionHistoryTask = task
        await task.value
    }

    @MainActor
    private func appendFetchTransactionHistory(
        startDate: Date,
        endDate: Date,
        transactionID: String,
        loopCounts: Int,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard !fetchTransactionHistoryState.isLoadingOrAppending,
            !transactionID.isEmpty,
            let startDate = truncateSeconds(of: startDate),
            let endDate = roundUpSeconds(of: endDate),
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value,
            let transactionHistory = fetchTransactionHistoryState.value
        else { return }

        fetchTransactionHistoryGeneration += 1
        let generation = fetchTransactionHistoryGeneration

        fetchTransactionHistoryTask?.cancel()
        fetchTransactionHistoryState.startAppendLoading()

        let environment = environment
        let task = Task {
            @MainActor [
                appStoreServerClient, startDate, endDate, transactionID, credential,
                rootCertificate, environment, transactionHistory
            ] in
            do {
                var merged = transactionHistory

                for _ in 0 ..< loopCounts {
                    guard let hasMore = merged.hasMore, hasMore,
                        let revision = merged.revision
                    else {
                        break
                    }

                    let model = try await appStoreServerClient.fetchTransactionHistory(
                        startDate: startDate,
                        endDate: endDate,
                        transactionID: transactionID,
                        revision: revision,
                        credential: credential,
                        rootCertificate: rootCertificate,
                        environment: environment
                    )
                    try Task.checkCancellation()

                    merged = .init(
                        revision: model.revision,
                        hasMore: model.hasMore,
                        bundleId: model.bundleId,
                        appAppleId: model.appAppleId,
                        environment: model.environment,
                        items: merged.items + model.items
                    )
                }

                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.finishAppendLoading(merged)
                fetchTransactionHistoryTask = nil
            } catch is CancellationError {
                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.finishAppendLoading(transactionHistory)
                fetchTransactionHistoryTask = nil
            } catch {
                guard generation == fetchTransactionHistoryGeneration else { return }
                fetchTransactionHistoryState.failAppendLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchTransactionHistoryTask = nil
            }
        }

        fetchTransactionHistoryTask = task
        await task.value
    }

    @MainActor
    private func fetchAllSubscriptionStatuses(
        transactionID: String,
        replacesInFlightRequest: Bool,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard replacesInFlightRequest || !fetchAllSubscriptionStatusesState.isLoadingOrAppending
        else { return }

        fetchAllSubscriptionStatusesGeneration += 1
        let generation = fetchAllSubscriptionStatusesGeneration

        fetchAllSubscriptionStatusesTask?.cancel()

        guard !transactionID.isEmpty,
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value
        else {
            if replacesInFlightRequest {
                fetchAllSubscriptionStatusesState.clear()
            }
            fetchAllSubscriptionStatusesTask = nil
            return
        }

        fetchAllSubscriptionStatusesState.restartLoading()

        let environment = environment
        let task = Task {
            @MainActor [
                appStoreServerClient, transactionID, credential, rootCertificate, environment
            ] in
            do {
                let model = try await appStoreServerClient.fetchAllSubscriptionStatuses(
                    transactionID: transactionID,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment
                )
                try Task.checkCancellation()

                guard generation == fetchAllSubscriptionStatusesGeneration else { return }
                fetchAllSubscriptionStatusesState.finishLoading(model)
                fetchAllSubscriptionStatusesTask = nil
            } catch is CancellationError {
                guard generation == fetchAllSubscriptionStatusesGeneration else { return }
                fetchAllSubscriptionStatusesState.clear()
                fetchAllSubscriptionStatusesTask = nil
            } catch {
                guard generation == fetchAllSubscriptionStatusesGeneration else { return }
                fetchAllSubscriptionStatusesState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchAllSubscriptionStatusesTask = nil
            }
        }

        fetchAllSubscriptionStatusesTask = task
        await task.value
    }

    @MainActor
    private func fetchTransactionInfo(
        transactionID: String,
        replacesInFlightRequest: Bool,
        appStoreServerClient: AppStoreServerClient
    ) async {
        guard replacesInFlightRequest || !fetchTransactionInfoState.isLoadingOrAppending else {
            return
        }

        fetchTransactionInfoGeneration += 1
        let generation = fetchTransactionInfoGeneration

        fetchTransactionInfoTask?.cancel()

        guard !transactionID.isEmpty,
            let credential = credentialState.value,
            let rootCertificate = rootCertificateState.value
        else {
            if replacesInFlightRequest {
                fetchTransactionInfoState.clear()
            }
            fetchTransactionInfoTask = nil
            return
        }

        fetchTransactionInfoState.restartLoading()

        let environment = environment
        let task = Task {
            @MainActor [
                appStoreServerClient, transactionID, credential, rootCertificate, environment
            ] in
            do {
                let model = try await appStoreServerClient.fetchTransactionInfo(
                    transactionID: transactionID,
                    credential: credential,
                    rootCertificate: rootCertificate,
                    environment: environment
                )
                try Task.checkCancellation()

                guard generation == fetchTransactionInfoGeneration else { return }
                fetchTransactionInfoState.finishLoading(model)
                fetchTransactionInfoTask = nil
            } catch is CancellationError {
                guard generation == fetchTransactionInfoGeneration else { return }
                fetchTransactionInfoState.clear()
                fetchTransactionInfoTask = nil
            } catch {
                guard generation == fetchTransactionInfoGeneration else { return }
                fetchTransactionInfoState.failLoading(
                    with: IAPError.unknownError(message: error.localizedDescription))
                fetchTransactionInfoTask = nil
            }
        }

        fetchTransactionInfoTask = task
        await task.value
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
