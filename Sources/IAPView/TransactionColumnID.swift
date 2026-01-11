//
//  TransactionColumnID.swift
//
//
//  Created by Claude on 2025/01/11.
//

import SwiftUI

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
