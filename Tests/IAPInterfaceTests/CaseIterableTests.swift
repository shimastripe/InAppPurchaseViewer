//
//  CaseIterableTests.swift
//  InAppPurchaseViewer
//
//  Created by Go TAKAGI on 2025/01/11.
//

import AppStoreServerLibrary
import Testing

@testable import IAPInterface

/// Tests to verify that our CaseIterable extensions cover all enum cases.
/// When AppStoreServerLibrary adds new enum cases, these tests help detect missing cases.
struct CaseIterableTests {

    // MARK: - NotificationTypeV2 Tests

    /// Verifies that all NotificationTypeV2 allCases have unique raw values
    @Test
    func notificationTypeV2AllCasesAreUnique() {
        let rawValues = NotificationTypeV2.allCases.map(\.rawValue)
        let uniqueRawValues = Set(rawValues)
        #expect(
            rawValues.count == uniqueRawValues.count,
            "NotificationTypeV2.allCases contains duplicate values"
        )
    }

    /// Verifies that all NotificationTypeV2 allCases are valid enum cases
    @Test
    func notificationTypeV2AllCasesAreValid() {
        for notificationType in NotificationTypeV2.allCases {
            // Accessing rawValue ensures the case is valid
            #expect(
                !notificationType.rawValue.isEmpty,
                "NotificationTypeV2 case has empty rawValue"
            )
        }
    }

    /// Documents the expected count of NotificationTypeV2 cases.
    /// UPDATE THIS TEST when AppStoreServerLibrary adds new NotificationTypeV2 cases.
    @Test
    func notificationTypeV2ExpectedCount() {
        // As of app-store-server-library-swift 4.0.0 (API v1.18)
        // Expected cases: subscribed, didChangeRenewalPref, didChangeRenewalStatus,
        // offerRedeemed, didRenew, expired, didFailToRenew, gracePeriodExpired,
        // priceIncrease, refund, refundDeclined, consumptionRequest, renewalExtended,
        // revoke, test, renewalExtension, refundReversed, externalPurchaseToken, oneTimeCharge
        let expectedCount = 19
        #expect(
            NotificationTypeV2.allCases.count == expectedCount,
            """
            NotificationTypeV2.allCases count changed.
            Expected \(expectedCount) but found \(NotificationTypeV2.allCases.count).
            If AppStoreServerLibrary added new cases, update:
            1. Sources/IAPInterface/Model/NotificationTypeV2+.swift - add new cases to allCases
            2. This test - update expectedCount
            """
        )
    }

    // MARK: - Subtype Tests

    /// Verifies that all Subtype allCases have unique raw values
    @Test
    func subtypeAllCasesAreUnique() {
        let rawValues = Subtype.allCases.map(\.rawValue)
        let uniqueRawValues = Set(rawValues)
        #expect(
            rawValues.count == uniqueRawValues.count,
            "Subtype.allCases contains duplicate values"
        )
    }

    /// Verifies that all Subtype allCases are valid enum cases
    @Test
    func subtypeAllCasesAreValid() {
        for subtype in Subtype.allCases {
            // Accessing rawValue ensures the case is valid
            #expect(
                !subtype.rawValue.isEmpty,
                "Subtype case has empty rawValue"
            )
        }
    }

    /// Documents the expected count of Subtype cases.
    /// UPDATE THIS TEST when AppStoreServerLibrary adds new Subtype cases.
    @Test
    func subtypeExpectedCount() {
        // As of app-store-server-library-swift 4.0.0 (API v1.18)
        // Expected cases: initialBuy, resubscribe, downgrade, upgrade,
        // autoRenewEnabled, autoRenewDisabled, voluntary, billingRetry,
        // priceIncrease, gracePeriod, pending, accepted, billingRecovery,
        // productNotForSale, summary, failure, unreported
        let expectedCount = 17
        #expect(
            Subtype.allCases.count == expectedCount,
            """
            Subtype.allCases count changed.
            Expected \(expectedCount) but found \(Subtype.allCases.count).
            If AppStoreServerLibrary added new cases, update:
            1. Sources/IAPInterface/Model/Subtype+.swift - add new cases to allCases
            2. This test - update expectedCount
            """
        )
    }

    // MARK: - NotificationFilterOption Tests

    /// Verifies that all NotificationFilterOption allOptions have unique ids
    @Test
    func notificationFilterOptionAllOptionsAreUnique() {
        let ids = NotificationFilterOption.allOptions.map(\.id)
        let uniqueIds = Set(ids)
        #expect(
            ids.count == uniqueIds.count,
            "NotificationFilterOption.allOptions contains duplicate ids"
        )
    }

    /// Documents the expected count of NotificationFilterOption options.
    /// UPDATE THIS TEST when the valid NotificationType/Subtype combinations change.
    @Test
    func notificationFilterOptionExpectedCount() {
        // Based on https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
        // Only includes explicitly documented combinations
        let expectedCount = 36
        #expect(
            NotificationFilterOption.allOptions.count == expectedCount,
            """
            NotificationFilterOption.allOptions count changed.
            Expected \(expectedCount) but found \(NotificationFilterOption.allOptions.count).
            Update Sources/IAPInterface/Model/NotificationFilterOption.swift if needed.
            """
        )
    }
}
