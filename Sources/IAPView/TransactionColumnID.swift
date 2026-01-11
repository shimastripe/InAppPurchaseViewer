//
//  TransactionColumnID.swift
//
//
//  Created by Claude on 2025/01/11.
//

import IAPInterface
import SwiftUI

/// Column width categories for transaction table
enum ColumnWidth: CGFloat {
    case small = 60  // Short values: price, currency, quantity, storefront
    case medium = 120  // Dates, most text fields
    case large = 140  // IDs, bundleId, productId
    case extraLarge = 180  // Long enum values: type, transactionReason
}

/// Unique identifiers for all transaction table columns.
/// Used with TableColumnCustomization for persistence and visibility control.
enum TransactionColumnID: String, CaseIterable, Identifiable, Codable {
    case purchaseDate
    case transactionReason
    case price
    case currency
    case originalTransactionID
    case transactionID
    case appTransactionId
    case originalPurchaseDate
    case expiresDate
    case offerIdentifier
    case offerType
    case offerDiscountType
    case offerPeriod
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
    case revocationDate
    case isUpgraded
    case signedDate

    var id: String { rawValue }

    /// Field name in lowerCamelCase matching Apple's API documentation
    var displayName: String {
        switch self {
        case .purchaseDate: "purchaseDate"
        case .transactionReason: "transactionReason"
        case .price: "price"
        case .currency: "currency"
        case .originalTransactionID: "originalTransactionId"
        case .transactionID: "transactionId"
        case .appTransactionId: "appTransactionId"
        case .originalPurchaseDate: "originalPurchaseDate"
        case .expiresDate: "expiresDate"
        case .offerIdentifier: "offerIdentifier"
        case .offerType: "offerType"
        case .offerDiscountType: "offerDiscountType"
        case .offerPeriod: "offerPeriod"
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
        case .revocationDate: "revocationDate"
        case .isUpgraded: "isUpgraded"
        case .signedDate: "signedDate"
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
        case .price, .currency, .quantity, .storefront:
            .small
        case .environment, .storefrontId:
            .medium
        case .purchaseDate, .originalPurchaseDate, .expiresDate, .revocationDate, .signedDate,
            .offerIdentifier, .offerType, .offerDiscountType, .offerPeriod,
            .appAccountToken, .revocationReason, .isUpgraded, .appTransactionId:
            .medium
        case .originalTransactionID, .transactionID, .bundleId, .productId, .webOrderLineItemId:
            .large
        case .transactionReason, .subscriptionGroupIdentifier, .inAppOwnershipType, .type:
            .extraLarge
        }
    }

    /// Extract display value from payload
    func value(from payload: JWSTransactionDecodedPayload) -> String? {
        switch self {
        case .purchaseDate:
            payload.purchaseDate?.formatted()
        case .transactionReason:
            payload.transactionReason?.rawValue
        case .price:
            payload.price?.description
        case .currency:
            payload.currency
        case .originalTransactionID:
            payload.originalTransactionId
        case .transactionID:
            payload.transactionId
        case .appTransactionId:
            payload.appTransactionId
        case .originalPurchaseDate:
            payload.originalPurchaseDate?.formatted()
        case .expiresDate:
            payload.expiresDate?.formatted()
        case .offerIdentifier:
            payload.offerIdentifier
        case .offerType:
            payload.offerType?.description
        case .offerDiscountType:
            payload.offerDiscountType?.rawValue
        case .offerPeriod:
            payload.offerPeriod
        case .appAccountToken:
            payload.appAccountToken?.uuidString
        case .bundleId:
            payload.bundleId
        case .productId:
            payload.productId
        case .subscriptionGroupIdentifier:
            payload.subscriptionGroupIdentifier
        case .quantity:
            payload.quantity?.description
        case .type:
            payload.type?.rawValue
        case .inAppOwnershipType:
            payload.inAppOwnershipType?.rawValue
        case .environment:
            payload.environment?.rawValue
        case .storefront:
            payload.storefront
        case .storefrontId:
            payload.storefrontId
        case .webOrderLineItemId:
            payload.webOrderLineItemId
        case .revocationReason:
            payload.revocationReason?.description
        case .revocationDate:
            payload.revocationDate?.formatted()
        case .isUpgraded:
            payload.isUpgraded?.description
        case .signedDate:
            payload.signedDate?.formatted()
        }
    }
}

/// Wrapper for storing column order in @SceneStorage
struct TransactionColumnOrder: RawRepresentable, Equatable, Hashable {
    var columns: [TransactionColumnID]

    init(columns: [TransactionColumnID] = TransactionColumnID.allCases) {
        self.columns = columns
    }

    init?(rawValue: String) {
        guard !rawValue.isEmpty else {
            self.columns = Array(TransactionColumnID.allCases)
            return
        }
        let ids = rawValue.split(separator: ",").compactMap {
            TransactionColumnID(rawValue: String($0))
        }
        // Ensure all columns are present (add any missing ones at the end)
        var result = ids
        for column in TransactionColumnID.allCases where !result.contains(column) {
            result.append(column)
        }
        self.columns = result
    }

    var rawValue: String {
        columns.map(\.rawValue).joined(separator: ",")
    }
}
