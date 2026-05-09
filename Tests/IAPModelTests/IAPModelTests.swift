//
//  IAPModelTests.swift
//
//
//  Created by Go TAKAGI on 2024/03/03.
//

import Dependencies
import IAPInterface
import XCTest

@testable import IAPModel

final class IAPModelTests: XCTestCase {

    func testLoadingViewStateIsLoadingOrAppending() {
        XCTAssertFalse(LoadingViewState<Int>.waiting.isLoadingOrAppending)
        XCTAssertTrue(LoadingViewState<Int>.loading.isLoadingOrAppending)
        XCTAssertTrue(LoadingViewState<Int>.appendLoading(1).isLoadingOrAppending)
        XCTAssertFalse(LoadingViewState<Int>.success(1).isLoadingOrAppending)
        XCTAssertFalse(
            LoadingViewState<Int>.failed(.unknownError(message: nil)).isLoadingOrAppending)
    }

    @MainActor
    func testReloadNotificationHistoryPrioritizesLatestRequest() async {
        let credential = IAPEnvironment(
            bundleID: "com.example.app",
            issuerID: "issuer-id",
            keyID: "key-id",
            appAppleID: 1_234_567_890,
            encodedKey: "private-key"
        )
        let firstResponse = NotificationHistoryModel(
            paginationToken: "first",
            hasMore: false,
            items: []
        )
        let secondResponse = NotificationHistoryModel(
            paginationToken: "second",
            hasMore: false,
            items: []
        )
        let fetchCoordinator = NotificationHistoryFetchCoordinator(
            firstResponse: firstResponse,
            secondResponse: secondResponse
        )

        await withDependencies {
            $0.calendar = Calendar(identifier: .gregorian)
            $0[CredentialClient.self] = .init(
                get: { credential },
                set: { _, _, _, _, _ in },
                remove: {}
            )
            $0[RootCertificateClient.self] = .init(
                fetch: { Data() },
                get: { Data([0x01]) },
                remove: {}
            )
            $0[AppStoreServerClient.self] = .init(
                fetchNotificationHistory: { _, _, _, _, _ in
                    await fetchCoordinator.fetch()
                },
                fetchTransactionHistory: { _, _, _, _, _, _, _ in
                    throw CancellationError()
                },
                fetchAllSubscriptionStatuses: { _, _, _, _ in
                    throw CancellationError()
                },
                fetchTransactionInfo: { _, _, _, _ in
                    throw CancellationError()
                }
            )
        } operation: {
            let model = IAPModel()
            await model.execute(action: .getCredential)
            await model.execute(action: .getRootCertificate)

            let firstFetchTask = Task {
                await model.execute(
                    action: .reloadNotificationHistory(
                        startDate: Date(timeIntervalSince1970: 0),
                        endDate: Date(timeIntervalSince1970: 60),
                        transactionID: ""
                    )
                )
            }

            await fetchCoordinator.waitForFirstStarted()
            XCTAssertTrue(model.fetchNotificationHistoryState.isLoadingOrAppending)

            let secondFetchTask = Task {
                await model.execute(
                    action: .reloadNotificationHistory(
                        startDate: Date(timeIntervalSince1970: 60),
                        endDate: Date(timeIntervalSince1970: 120),
                        transactionID: ""
                    )
                )
            }

            await fetchCoordinator.waitForSecondStarted()
            await fetchCoordinator.finishSecond()
            await secondFetchTask.value

            XCTAssertEqual(model.fetchNotificationHistoryState.value, secondResponse)

            await fetchCoordinator.finishFirst()
            await firstFetchTask.value

            XCTAssertEqual(model.fetchNotificationHistoryState.value, secondResponse)
            let numberOfCalls = await fetchCoordinator.numberOfCalls()
            XCTAssertEqual(numberOfCalls, 2)
        }
    }
}

private actor NotificationHistoryFetchCoordinator {
    private let firstResponse: NotificationHistoryModel
    private let secondResponse: NotificationHistoryModel

    private let firstStarted = AsyncStream<Void>.makeStream(of: Void.self)
    private let secondStarted = AsyncStream<Void>.makeStream(of: Void.self)
    private let firstFinished = AsyncStream<Void>.makeStream(of: Void.self)
    private let secondFinished = AsyncStream<Void>.makeStream(of: Void.self)

    private var callCount = 0

    init(firstResponse: NotificationHistoryModel, secondResponse: NotificationHistoryModel) {
        self.firstResponse = firstResponse
        self.secondResponse = secondResponse
    }

    func fetch() async -> NotificationHistoryModel {
        callCount += 1

        switch callCount {
        case 1:
            firstStarted.continuation.yield()
            await waitUntilFinished(firstFinished.stream)
            return firstResponse
        case 2:
            secondStarted.continuation.yield()
            await waitUntilFinished(secondFinished.stream)
            return secondResponse
        default:
            return secondResponse
        }
    }

    func waitForFirstStarted() async {
        await waitUntilFinished(firstStarted.stream)
    }

    func waitForSecondStarted() async {
        await waitUntilFinished(secondStarted.stream)
    }

    func finishFirst() {
        firstFinished.continuation.yield()
        firstFinished.continuation.finish()
    }

    func finishSecond() {
        secondFinished.continuation.yield()
        secondFinished.continuation.finish()
    }

    func numberOfCalls() -> Int {
        callCount
    }

    private func waitUntilFinished(_ stream: AsyncStream<Void>) async {
        var iterator = stream.makeAsyncIterator()
        _ = await iterator.next()
    }
}
