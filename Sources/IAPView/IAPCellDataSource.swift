//
//  IAPCellDataSource.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/09/29.
//

import Foundation
import IAPInterface

struct IAPCellDataSource: Sendable, Identifiable {
    let keyPath: PartialKeyPath<JWSTransactionDecodedPayload> & Sendable
    let name: String
    let idealWidth: CGFloat
    var isOn: Bool

    var id: PartialKeyPath<JWSTransactionDecodedPayload> & Sendable { keyPath }
}

extension IAPCellDataSource {
    static let defaultTransactionInfo: [IAPCellDataSource] = [
        .init(
            keyPath: \JWSTransactionDecodedPayload.purchaseDate,
            name: "purchaseDate",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.transactionReason,
            name: "transactionReason",
            idealWidth: 160,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.price,
            name: "price",
            idealWidth: 60,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.currency,
            name: "currency",
            idealWidth: 60,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.originalTransactionId,
            name: "originalTransactionId",
            idealWidth: 140,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.transactionId,
            name: "transactionId",
            idealWidth: 140,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.originalPurchaseDate,
            name: "originalPurchaseDate",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.expiresDate,
            name: "expiresDate",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.offerIdentifier,
            name: "offerIdentifier",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.offerType,
            name: "offerType",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.offerDiscountType,
            name: "offerDiscountType",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.appAccountToken,
            name: "appAccountToken",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.bundleId,
            name: "bundleId",
            idealWidth: 140,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.productId,
            name: "productId",
            idealWidth: 140,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.subscriptionGroupIdentifier,
            name: "subscriptionGroupIdentifier",
            idealWidth: 160,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.quantity,
            name: "quantity",
            idealWidth: 60,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.type,
            name: "type",
            idealWidth: 180,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.inAppOwnershipType,
            name: "inAppOwnershipType",
            idealWidth: 160,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.environment,
            name: "environment",
            idealWidth: 80,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.storefront,
            name: "storefront",
            idealWidth: 60,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.storefrontId,
            name: "storefrontId",
            idealWidth: 80,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.webOrderLineItemId,
            name: "webOrderLineItemId",
            idealWidth: 140,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.revocationReason,
            name: "revocationReason",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.revocationDate,
            name: "revocationDate",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.isUpgraded,
            name: "isUpgraded",
            idealWidth: 120,
            isOn: true
        ),
        .init(
            keyPath: \JWSTransactionDecodedPayload.signedDate,
            name: "signedDate",
            idealWidth: 120,
            isOn: true
        ),
    ]
}
