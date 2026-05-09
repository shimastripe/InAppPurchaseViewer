//
//  NotificationColumnID.swift
//
//
//  Created by Claude on 2025/01/12.
//

import IAPInterface
import SwiftUI

/// Unique identifiers for all notification history table columns.
/// Used with TableColumnCustomization for persistence and visibility control.
enum NotificationColumnID: String, CaseIterable, Identifiable, Codable {
    // Main columns (10)
    case signedDate
    case notificationType
    case subType
    case price
    case currency
    case originalTransactionID
    case transactionID
    case originalPurchaseDate
    case purchaseDate
    case expiresDate

    // External columns (3)
    case consumptionRequestReason
    case externalPurchaseId
    case tokenCreationDate

    // App Data columns (4)
    case appDataAppAppleId
    case appDataBundleId
    case appDataEnvironment
    case appDataSignedAppTransactionInfo

    // Transaction columns (29)
    case notificationUUID
    case transactionReason
    case offerIdentifier
    case offerType
    case offerDiscountType
    case appAccountToken
    case bundleId
    case productId
    case subscriptionGroupIdentifier
    case quantity
    case type
    case inAppOwnershipType
    case environment
    case storefront
    case storefrontId
    case webOrderLineItemId
    case revocationReason
    case revocationType
    case revocationPercentage
    case revocationDate
    case isUpgraded
    case transactionSignedDate
    case transactionAppTransactionId
    case transactionOfferPeriod
    case billingPlanType
    case commitmentBillingPeriodNumber
    case commitmentTotalBillingPeriods
    case commitmentExpiresDate
    case commitmentPrice

    // Renewal Info columns (30)
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
    case renewalBillingPlanType
    case renewalCommitmentAutoRenewProductId
    case renewalCommitmentAutoRenewStatus
    case renewalCommitmentRenewalBillingPlanType
    case renewalCommitmentRenewalDate
    case renewalCommitmentRenewalPrice
    case advancedCommercePriceIncreaseInfoDependentSKU
    case advancedCommercePriceIncreaseInfoStatus
    case advancedCommercePriceIncreaseInfoPrice

    var id: String { rawValue }

    /// Field name for display
    var displayName: String {
        switch self {
        // Main
        case .signedDate: "signedDate"
        case .notificationType: "notificationType"
        case .subType: "subtype"
        case .price: "price"
        case .currency: "currency"
        case .originalTransactionID: "originalTransactionId"
        case .transactionID: "transactionId"
        case .originalPurchaseDate: "originalPurchaseDate"
        case .purchaseDate: "purchaseDate"
        case .expiresDate: "expiresDate"
        // External
        case .consumptionRequestReason: "consumptionRequestReason"
        case .externalPurchaseId: "externalPurchaseId"
        case .tokenCreationDate: "tokenCreationDate"
        // App Data
        case .appDataAppAppleId: "appAppleId"
        case .appDataBundleId: "bundleId"
        case .appDataEnvironment: "environment"
        case .appDataSignedAppTransactionInfo: "signedAppTransactionInfo"
        // Transaction
        case .notificationUUID: "notificationUUID"
        case .transactionReason: "transactionReason"
        case .offerIdentifier: "offerIdentifier"
        case .offerType: "offerType"
        case .offerDiscountType: "offerDiscountType"
        case .appAccountToken: "appAccountToken"
        case .bundleId: "bundleId"
        case .productId: "productId"
        case .subscriptionGroupIdentifier: "subscriptionGroupIdentifier"
        case .quantity: "quantity"
        case .type: "type"
        case .inAppOwnershipType: "inAppOwnershipType"
        case .environment: "environment"
        case .storefront: "storefront"
        case .storefrontId: "storefrontId"
        case .webOrderLineItemId: "webOrderLineItemId"
        case .revocationReason: "revocationReason"
        case .revocationType: "revocationType"
        case .revocationPercentage: "revocationPercentage"
        case .revocationDate: "revocationDate"
        case .isUpgraded: "isUpgraded"
        case .transactionSignedDate: "signedDate"
        case .transactionAppTransactionId: "appTransactionId"
        case .transactionOfferPeriod: "offerPeriod"
        case .billingPlanType: "billingPlanType"
        case .commitmentBillingPeriodNumber: "billingPeriodNumber"
        case .commitmentTotalBillingPeriods: "totalBillingPeriods"
        case .commitmentExpiresDate: "commitmentExpiresDate"
        case .commitmentPrice: "commitmentPrice"
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
        case .renewalBillingPlanType: "renewalBillingPlanType"
        case .renewalCommitmentAutoRenewProductId: "commitmentAutoRenewProductId"
        case .renewalCommitmentAutoRenewStatus: "commitmentAutoRenewStatus"
        case .renewalCommitmentRenewalBillingPlanType: "commitmentRenewalBillingPlanType"
        case .renewalCommitmentRenewalDate: "commitmentRenewalDate"
        case .renewalCommitmentRenewalPrice: "commitmentRenewalPrice"
        case .advancedCommercePriceIncreaseInfoDependentSKU:
            "advancedCommercePriceIncreaseInfoDependentSKU"
        case .advancedCommercePriceIncreaseInfoStatus: "advancedCommercePriceIncreaseInfoStatus"
        case .advancedCommercePriceIncreaseInfoPrice: "advancedCommercePriceIncreaseInfoPrice"
        }
    }

    /// Column header text (with prefix for duplicates)
    var columnHeader: String {
        switch self {
        case .transactionSignedDate: "transaction signedDate"
        case .transactionAppTransactionId: "transaction appTransactionId"
        case .transactionOfferPeriod: "transaction offerPeriod"
        case .appDataAppAppleId: "appData.appAppleId"
        case .appDataBundleId: "appData.bundleId"
        case .appDataEnvironment: "appData.environment"
        case .appDataSignedAppTransactionInfo: "appData.signedAppTransactionInfo"
        case .commitmentBillingPeriodNumber: "commitmentInfo.billingPeriodNumber"
        case .commitmentTotalBillingPeriods: "commitmentInfo.totalBillingPeriods"
        case .commitmentExpiresDate: "commitmentInfo.commitmentExpiresDate"
        case .commitmentPrice: "commitmentInfo.commitmentPrice"
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
        case .renewalCommitmentAutoRenewProductId:
            "renewal commitmentInfo.commitmentAutoRenewProductId"
        case .renewalCommitmentAutoRenewStatus:
            "renewal commitmentInfo.commitmentAutoRenewStatus"
        case .renewalCommitmentRenewalBillingPlanType:
            "renewal commitmentInfo.commitmentRenewalBillingPlanType"
        case .renewalCommitmentRenewalDate:
            "renewal commitmentInfo.commitmentRenewalDate"
        case .renewalCommitmentRenewalPrice:
            "renewal commitmentInfo.commitmentRenewalPrice"
        case .advancedCommercePriceIncreaseInfoDependentSKU:
            "advancedCommercePriceIncreaseInfo.dependentSKU"
        case .advancedCommercePriceIncreaseInfoStatus:
            "advancedCommercePriceIncreaseInfo.status"
        case .advancedCommercePriceIncreaseInfoPrice:
            "advancedCommercePriceIncreaseInfo.price"
        default: displayName
        }
    }

    /// URL to Apple's API documentation for this field
    var documentationURL: URL {
        let baseURL =
            switch self {
            case .appDataAppAppleId, .appDataBundleId, .appDataEnvironment,
                .appDataSignedAppTransactionInfo:
                "https://developer.apple.com/documentation/appstoreservernotifications/"
            default:
                "https://developer.apple.com/documentation/appstoreserverapi/"
            }
        return URL(string: baseURL + displayName.lowercased())!
    }

    /// Column width category
    var width: ColumnWidth {
        switch self {
        case .price, .currency, .quantity, .storefront, .renewalCurrency,
            .commitmentBillingPeriodNumber, .commitmentTotalBillingPeriods,
            .revocationPercentage:
            .small
        case .environment, .storefrontId, .renewalEnvironment, .appDataEnvironment,
            .billingPlanType, .revocationType, .renewalBillingPlanType,
            .renewalCommitmentAutoRenewStatus, .renewalCommitmentRenewalBillingPlanType:
            .medium
        case .notificationType, .subscriptionGroupIdentifier, .type, .inAppOwnershipType,
            .recentSubscriptionStartDate, .consumptionRequestReason, .subType,
            .appDataSignedAppTransactionInfo, .advancedCommercePriceIncreaseInfoDependentSKU:
            .extraLarge
        case .originalTransactionID, .transactionID, .bundleId, .productId,
            .webOrderLineItemId, .renewalOriginalTransactionId, .renewalProductId,
            .notificationUUID, .appDataBundleId, .renewalCommitmentAutoRenewProductId:
            .large
        default:
            .medium
        }
    }

    /// Category grouping for organized Inspector display
    var category: ColumnCategory {
        switch self {
        case .signedDate, .notificationType, .subType, .price, .currency,
            .originalTransactionID, .transactionID, .originalPurchaseDate,
            .purchaseDate, .expiresDate:
            .main
        case .consumptionRequestReason, .externalPurchaseId, .tokenCreationDate:
            .external
        case .appDataAppAppleId, .appDataBundleId, .appDataEnvironment,
            .appDataSignedAppTransactionInfo:
            .appData
        case .notificationUUID, .transactionReason, .offerIdentifier, .offerType,
            .offerDiscountType, .appAccountToken, .bundleId, .productId,
            .subscriptionGroupIdentifier, .quantity, .type, .inAppOwnershipType,
            .environment, .storefront, .storefrontId, .webOrderLineItemId,
            .revocationReason, .revocationType, .revocationPercentage, .revocationDate,
            .isUpgraded, .transactionSignedDate, .transactionAppTransactionId,
            .transactionOfferPeriod, .billingPlanType, .commitmentBillingPeriodNumber,
            .commitmentTotalBillingPeriods, .commitmentExpiresDate, .commitmentPrice:
            .transaction
        case .expirationIntent, .renewalOriginalTransactionId, .autoRenewProductId,
            .renewalProductId, .autoRenewStatus, .isInBillingRetryPeriod,
            .priceIncreaseStatus, .gracePeriodExpiresDate, .renewalOfferType,
            .renewalOfferIdentifier, .renewalSignedDate, .renewalEnvironment,
            .recentSubscriptionStartDate, .renewalDate, .renewalPrice,
            .renewalCurrency, .renewalOfferDiscountType, .eligibleWinBackOfferIds,
            .renewalAppTransactionId, .renewalOfferPeriod, .renewalAppAccountToken,
            .renewalBillingPlanType, .renewalCommitmentAutoRenewProductId,
            .renewalCommitmentAutoRenewStatus, .renewalCommitmentRenewalBillingPlanType,
            .renewalCommitmentRenewalDate, .renewalCommitmentRenewalPrice,
            .advancedCommercePriceIncreaseInfoDependentSKU,
            .advancedCommercePriceIncreaseInfoStatus, .advancedCommercePriceIncreaseInfoPrice:
            .renewalInfo
        }
    }

    enum ColumnCategory: String, CaseIterable {
        case main = "Main"
        case external = "External"
        case appData = "App Data"
        case transaction = "Transaction"
        case renewalInfo = "Renewal Info"
    }

    /// Icon info for columns that display icons
    struct IconInfo {
        let systemName: String
        let color: Color
    }

    /// Get icon info for this column from the item (only for columns with icons)
    func iconInfo(from item: NotificationHistoryItem) -> IconInfo? {
        switch self {
        case .notificationType:
            return IconInfo(systemName: item.eventIcon, color: item.eventColor)
        default:
            return nil
        }
    }

    /// Extract display value from NotificationHistoryItem
    func value(from item: NotificationHistoryItem) -> String? {
        switch self {
        // Main
        case .signedDate:
            item.signedDate?.formatted()
        case .notificationType:
            item.notificationType?.rawValue
        case .subType:
            item.subType?.rawValue
        case .price:
            item.transactionInfo?.price?.description
        case .currency:
            item.transactionInfo?.currency
        case .originalTransactionID:
            item.transactionInfo?.originalTransactionId
        case .transactionID:
            item.transactionInfo?.transactionId
        case .originalPurchaseDate:
            item.transactionInfo?.originalPurchaseDate?.formatted()
        case .purchaseDate:
            item.transactionInfo?.purchaseDate?.formatted()
        case .expiresDate:
            item.transactionInfo?.expiresDate?.formatted()
        // External
        case .consumptionRequestReason:
            item.consumptionRequestReason?.rawValue
        case .externalPurchaseId:
            item.externalPurchaseToken?.externalPurchaseId
        case .tokenCreationDate:
            item.externalPurchaseToken?.tokenCreationDate.map {
                Date(timeIntervalSince1970: TimeInterval($0))
            }?.formatted()
        // App Data
        case .appDataAppAppleId:
            item.appData?.appAppleId?.description
        case .appDataBundleId:
            item.appData?.bundleId
        case .appDataEnvironment:
            item.appData?.environment?.rawValue
        case .appDataSignedAppTransactionInfo:
            item.appData?.signedAppTransactionInfo
        // Transaction
        case .notificationUUID:
            item.id.rawValue
        case .transactionReason:
            item.transactionInfo?.transactionReason?.rawValue
        case .offerIdentifier:
            item.transactionInfo?.offerIdentifier
        case .offerType:
            item.transactionInfo?.offerType?.description
        case .offerDiscountType:
            item.transactionInfo?.offerDiscountType?.rawValue
        case .appAccountToken:
            item.transactionInfo?.appAccountToken?.uuidString
        case .bundleId:
            item.transactionInfo?.bundleId
        case .productId:
            item.transactionInfo?.productId
        case .subscriptionGroupIdentifier:
            item.transactionInfo?.subscriptionGroupIdentifier
        case .quantity:
            item.transactionInfo?.quantity?.description
        case .type:
            item.transactionInfo?.type?.rawValue
        case .inAppOwnershipType:
            item.transactionInfo?.inAppOwnershipType?.rawValue
        case .environment:
            item.transactionInfo?.environment?.rawValue
        case .storefront:
            item.transactionInfo?.storefront
        case .storefrontId:
            item.transactionInfo?.storefrontId
        case .webOrderLineItemId:
            item.transactionInfo?.webOrderLineItemId
        case .revocationReason:
            item.transactionInfo?.revocationReason?.description
        case .revocationType:
            item.transactionInfo?.revocationType?.rawValue
        case .revocationPercentage:
            item.transactionInfo?.revocationPercentage?.description
        case .revocationDate:
            item.transactionInfo?.revocationDate?.formatted()
        case .isUpgraded:
            item.transactionInfo?.isUpgraded?.description
        case .transactionSignedDate:
            item.transactionInfo?.signedDate?.formatted()
        case .transactionAppTransactionId:
            item.transactionInfo?.appTransactionId
        case .transactionOfferPeriod:
            item.transactionInfo?.offerPeriod
        case .billingPlanType:
            item.transactionInfo?.billingPlanType?.rawValue
        case .commitmentBillingPeriodNumber:
            item.transactionInfo?.commitmentBillingPeriodNumberDescription
        case .commitmentTotalBillingPeriods:
            item.transactionInfo?.commitmentTotalBillingPeriodsDescription
        case .commitmentExpiresDate:
            item.transactionInfo?.commitmentExpiresDateDescription
        case .commitmentPrice:
            item.transactionInfo?.commitmentPriceDescription
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
        case .renewalBillingPlanType:
            item.renewalInfo?.renewalBillingPlanType?.rawValue
        case .renewalCommitmentAutoRenewProductId:
            item.renewalInfo?.commitmentInfo?.commitmentAutoRenewProductId
        case .renewalCommitmentAutoRenewStatus:
            item.renewalInfo?.commitmentAutoRenewStatusDescription
        case .renewalCommitmentRenewalBillingPlanType:
            item.renewalInfo?.commitmentInfo?.commitmentRenewalBillingPlanType?.rawValue
        case .renewalCommitmentRenewalDate:
            item.renewalInfo?.commitmentRenewalDateDescription
        case .renewalCommitmentRenewalPrice:
            item.renewalInfo?.commitmentRenewalPriceDescription
        case .advancedCommercePriceIncreaseInfoDependentSKU:
            item.renewalInfo?.advancedCommercePriceIncreaseInfoDependentSKUDescription
        case .advancedCommercePriceIncreaseInfoStatus:
            item.renewalInfo?.advancedCommercePriceIncreaseInfoStatusDescription
        case .advancedCommercePriceIncreaseInfoPrice:
            item.renewalInfo?.advancedCommercePriceIncreaseInfoPriceDescription
        }
    }
}

/// Wrapper for storing column order in @SceneStorage
struct NotificationColumnOrder: RawRepresentable, Equatable, Hashable {
    var columns: [NotificationColumnID]

    init(columns: [NotificationColumnID] = NotificationColumnID.allCases) {
        self.columns = columns
    }

    init?(rawValue: String) {
        guard !rawValue.isEmpty else {
            self.columns = Array(NotificationColumnID.allCases)
            return
        }
        let ids = rawValue.split(separator: ",").compactMap {
            NotificationColumnID(rawValue: String($0))
        }
        // Ensure all columns are present (add any missing ones at the end)
        var result = ids
        for column in NotificationColumnID.allCases where !result.contains(column) {
            result.append(column)
        }
        self.columns = result
    }

    var rawValue: String {
        columns.map(\.rawValue).joined(separator: ",")
    }
}
