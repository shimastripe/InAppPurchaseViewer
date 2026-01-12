//
//  SubscriptionColumnID.swift
//
//
//  Created by Claude on 2025/01/12.
//

import IAPInterface
import SwiftUI

/// Unique identifiers for all subscription status table columns.
/// Used with TableColumnCustomization for persistence and visibility control.
enum SubscriptionColumnID: String, CaseIterable, Identifiable, Codable {
    // Main columns (9)
    case subscriptionGroupIdentifier
    case status
    case price
    case currency
    case originalTransactionID
    case transactionID
    case originalPurchaseDate
    case purchaseDate
    case expiresDate

    // Transaction columns (20)
    case transactionReason
    case offerIdentifier
    case offerType
    case offerDiscountType
    case appAccountToken
    case bundleId
    case productId
    case quantity
    case type
    case inAppOwnershipType
    case environment
    case storefront
    case storefrontId
    case webOrderLineItemId
    case revocationReason
    case revocationDate
    case isUpgraded
    case transactionSignedDate
    case appTransactionId
    case offerPeriod

    // Renewal Info columns (21)
    case expirationIntent
    case renewalOriginalTransactionId
    case autoRenewProductId
    case renewalProductId
    case autoRenewStatus
    case isInBillingRetryPeriod
    case priceIncreaseStatus
    case gracePeriodExpiresDate
    case renewalOfferType
    case renewalOfferIdentifier
    case renewalSignedDate
    case renewalEnvironment
    case recentSubscriptionStartDate
    case renewalDate
    case renewalPrice
    case renewalCurrency
    case renewalOfferDiscountType
    case eligibleWinBackOfferIds
    case renewalAppTransactionId
    case renewalOfferPeriod
    case renewalAppAccountToken

    var id: String { rawValue }

    /// Field name for display
    var displayName: String {
        switch self {
        // Main
        case .subscriptionGroupIdentifier: "subscriptionGroupIdentifier"
        case .status: "status"
        case .price: "price"
        case .currency: "currency"
        case .originalTransactionID: "originalTransactionId"
        case .transactionID: "transactionId"
        case .originalPurchaseDate: "originalPurchaseDate"
        case .purchaseDate: "purchaseDate"
        case .expiresDate: "expiresDate"
        // Transaction
        case .transactionReason: "transactionReason"
        case .offerIdentifier: "offerIdentifier"
        case .offerType: "offerType"
        case .offerDiscountType: "offerDiscountType"
        case .appAccountToken: "appAccountToken"
        case .bundleId: "bundleId"
        case .productId: "productId"
        case .quantity: "quantity"
        case .type: "type"
        case .inAppOwnershipType: "inAppOwnershipType"
        case .environment: "environment"
        case .storefront: "storefront"
        case .storefrontId: "storefrontId"
        case .webOrderLineItemId: "webOrderLineItemId"
        case .revocationReason: "revocationReason"
        case .revocationDate: "revocationDate"
        case .isUpgraded: "isUpgraded"
        case .transactionSignedDate: "signedDate"
        case .appTransactionId: "appTransactionId"
        case .offerPeriod: "offerPeriod"
        // Renewal Info
        case .expirationIntent: "expirationIntent"
        case .renewalOriginalTransactionId: "originalTransactionId"
        case .autoRenewProductId: "autoRenewProductId"
        case .renewalProductId: "productId"
        case .autoRenewStatus: "autoRenewStatus"
        case .isInBillingRetryPeriod: "isInBillingRetryPeriod"
        case .priceIncreaseStatus: "priceIncreaseStatus"
        case .gracePeriodExpiresDate: "gracePeriodExpiresDate"
        case .renewalOfferType: "offerType"
        case .renewalOfferIdentifier: "offerIdentifier"
        case .renewalSignedDate: "signedDate"
        case .renewalEnvironment: "environment"
        case .recentSubscriptionStartDate: "recentSubscriptionStartDate"
        case .renewalDate: "renewalDate"
        case .renewalPrice: "renewalPrice"
        case .renewalCurrency: "currency"
        case .renewalOfferDiscountType: "offerDiscountType"
        case .eligibleWinBackOfferIds: "eligibleWinBackOfferIds"
        case .renewalAppTransactionId: "appTransactionId"
        case .renewalOfferPeriod: "offerPeriod"
        case .renewalAppAccountToken: "appAccountToken"
        }
    }

    /// Column header text (with prefix for renewal info duplicates)
    var columnHeader: String {
        switch self {
        case .transactionSignedDate: "transaction signedDate"
        case .renewalOriginalTransactionId: "renewal originalTransactionId"
        case .renewalProductId: "renewal productId"
        case .renewalOfferType: "renewal offerType"
        case .renewalOfferIdentifier: "renewal offerIdentifier"
        case .renewalSignedDate: "renewal signedDate"
        case .renewalEnvironment: "renewal environment"
        case .renewalCurrency: "renewal currency"
        case .renewalOfferDiscountType: "renewal offerDiscountType"
        case .renewalAppTransactionId: "renewal appTransactionId"
        case .renewalOfferPeriod: "renewal offerPeriod"
        case .renewalAppAccountToken: "renewal appAccountToken"
        default: displayName
        }
    }

    /// URL to Apple's API documentation for this field
    var documentationURL: URL {
        let baseURL = "https://developer.apple.com/documentation/appstoreserverapi/"
        return URL(string: baseURL + displayName.lowercased())!
    }

    /// Column width category
    var width: ColumnWidth {
        switch self {
        case .price, .currency, .quantity, .storefront, .renewalCurrency:
            .small
        case .environment, .storefrontId, .renewalEnvironment:
            .medium
        case .subscriptionGroupIdentifier, .status, .type, .inAppOwnershipType,
            .recentSubscriptionStartDate:
            .extraLarge
        case .originalTransactionID, .transactionID, .bundleId, .productId,
            .webOrderLineItemId, .renewalOriginalTransactionId, .renewalProductId:
            .large
        default:
            .medium
        }
    }

    /// Category grouping for organized Inspector display
    var category: ColumnCategory {
        switch self {
        case .subscriptionGroupIdentifier, .status, .price, .currency,
            .originalTransactionID, .transactionID, .originalPurchaseDate,
            .purchaseDate, .expiresDate:
            .main
        case .transactionReason, .offerIdentifier, .offerType, .offerDiscountType,
            .appAccountToken, .bundleId, .productId, .quantity, .type,
            .inAppOwnershipType, .environment, .storefront, .storefrontId,
            .webOrderLineItemId, .revocationReason, .revocationDate, .isUpgraded,
            .transactionSignedDate, .appTransactionId, .offerPeriod:
            .transaction
        case .expirationIntent, .renewalOriginalTransactionId, .autoRenewProductId,
            .renewalProductId, .autoRenewStatus, .isInBillingRetryPeriod,
            .priceIncreaseStatus, .gracePeriodExpiresDate, .renewalOfferType,
            .renewalOfferIdentifier, .renewalSignedDate, .renewalEnvironment,
            .recentSubscriptionStartDate, .renewalDate, .renewalPrice,
            .renewalCurrency, .renewalOfferDiscountType, .eligibleWinBackOfferIds,
            .renewalAppTransactionId, .renewalOfferPeriod, .renewalAppAccountToken:
            .renewalInfo
        }
    }

    enum ColumnCategory: String, CaseIterable {
        case main = "Main"
        case transaction = "Transaction"
        case renewalInfo = "Renewal Info"
    }

    /// Icon info for columns that display icons
    struct IconInfo {
        let systemName: String
        let color: Color
    }

    /// Get icon info for this column from the item (only for columns with icons)
    func iconInfo(from item: LastTransaction) -> IconInfo? {
        switch self {
        case .status:
            guard let status = item.status else { return nil }
            return IconInfo(systemName: status.eventIcon, color: status.eventColor)
        default:
            return nil
        }
    }

    /// Extract display value from LastTransaction
    func value(from item: LastTransaction) -> String? {
        switch self {
        // Main
        case .subscriptionGroupIdentifier:
            item.transaction?.subscriptionGroupIdentifier
        case .status:
            item.status?.description
        case .price:
            item.transaction?.price?.description
        case .currency:
            item.transaction?.currency
        case .originalTransactionID:
            item.transaction?.originalTransactionId
        case .transactionID:
            item.transaction?.transactionId
        case .originalPurchaseDate:
            item.transaction?.originalPurchaseDate?.formatted()
        case .purchaseDate:
            item.transaction?.purchaseDate?.formatted()
        case .expiresDate:
            item.transaction?.expiresDate?.formatted()
        // Transaction
        case .transactionReason:
            item.transaction?.transactionReason?.rawValue
        case .offerIdentifier:
            item.transaction?.offerIdentifier
        case .offerType:
            item.transaction?.offerType?.description
        case .offerDiscountType:
            item.transaction?.offerDiscountType?.rawValue
        case .appAccountToken:
            item.transaction?.appAccountToken?.uuidString
        case .bundleId:
            item.transaction?.bundleId
        case .productId:
            item.transaction?.productId
        case .quantity:
            item.transaction?.quantity?.description
        case .type:
            item.transaction?.type?.rawValue
        case .inAppOwnershipType:
            item.transaction?.inAppOwnershipType?.rawValue
        case .environment:
            item.transaction?.environment?.rawValue
        case .storefront:
            item.transaction?.storefront
        case .storefrontId:
            item.transaction?.storefrontId
        case .webOrderLineItemId:
            item.transaction?.webOrderLineItemId
        case .revocationReason:
            item.transaction?.revocationReason?.description
        case .revocationDate:
            item.transaction?.revocationDate?.formatted()
        case .isUpgraded:
            item.transaction?.isUpgraded?.description
        case .transactionSignedDate:
            item.transaction?.signedDate?.formatted()
        case .appTransactionId:
            item.transaction?.appTransactionId
        case .offerPeriod:
            item.transaction?.offerPeriod
        // Renewal Info
        case .expirationIntent:
            item.renewalInfo?.expirationIntent?.description
        case .renewalOriginalTransactionId:
            item.renewalInfo?.originalTransactionId
        case .autoRenewProductId:
            item.renewalInfo?.autoRenewProductId
        case .renewalProductId:
            item.renewalInfo?.productId
        case .autoRenewStatus:
            item.renewalInfo?.autoRenewStatus?.description
        case .isInBillingRetryPeriod:
            item.renewalInfo?.isInBillingRetryPeriod?.description
        case .priceIncreaseStatus:
            item.renewalInfo?.priceIncreaseStatus?.description
        case .gracePeriodExpiresDate:
            item.renewalInfo?.gracePeriodExpiresDate?.formatted()
        case .renewalOfferType:
            item.renewalInfo?.offerType?.description
        case .renewalOfferIdentifier:
            item.renewalInfo?.offerIdentifier
        case .renewalSignedDate:
            item.renewalInfo?.signedDate?.formatted()
        case .renewalEnvironment:
            item.renewalInfo?.environment?.rawValue
        case .recentSubscriptionStartDate:
            item.renewalInfo?.recentSubscriptionStartDate?.formatted()
        case .renewalDate:
            item.renewalInfo?.renewalDate?.formatted()
        case .renewalPrice:
            item.renewalInfo?.renewalPrice?.description
        case .renewalCurrency:
            item.renewalInfo?.currency
        case .renewalOfferDiscountType:
            item.renewalInfo?.offerDiscountType?.rawValue
        case .eligibleWinBackOfferIds:
            item.renewalInfo?.eligibleWinBackOfferIds?.joined(separator: ", ")
        case .renewalAppTransactionId:
            item.renewalInfo?.appTransactionId
        case .renewalOfferPeriod:
            item.renewalInfo?.offerPeriod
        case .renewalAppAccountToken:
            item.renewalInfo?.appAccountToken?.uuidString
        }
    }
}

/// Wrapper for storing column order in @SceneStorage
struct SubscriptionColumnOrder: RawRepresentable, Equatable, Hashable {
    var columns: [SubscriptionColumnID]

    init(columns: [SubscriptionColumnID] = SubscriptionColumnID.allCases) {
        self.columns = columns
    }

    init?(rawValue: String) {
        guard !rawValue.isEmpty else {
            self.columns = Array(SubscriptionColumnID.allCases)
            return
        }
        let ids = rawValue.split(separator: ",").compactMap {
            SubscriptionColumnID(rawValue: String($0))
        }
        // Ensure all columns are present (add any missing ones at the end)
        var result = ids
        for column in SubscriptionColumnID.allCases where !result.contains(column) {
            result.append(column)
        }
        self.columns = result
    }

    var rawValue: String {
        columns.map(\.rawValue).joined(separator: ",")
    }
}
