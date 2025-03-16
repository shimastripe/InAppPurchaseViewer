//
//  TransactionHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import IAPInterface
import SwiftUI

struct TransactionHistoryTableView: View {

    private let columnCounts = 26

    @ScaledMetric private var iconSize: CGFloat = 20

    let model: TransactionHistory

    @Binding var currentColumns: [IAPCellDataSource.TransactionDecodedPayload]

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    func column(dataSource: IAPCellDataSource.TransactionDecodedPayload) -> some TableColumnContent<
        JWSTransactionDecodedPayload, Never
    > {
        TableColumn(dataSource.name) { item in
            let stringKeyPaths = [
                \JWSTransactionDecodedPayload.originalTransactionId,
                \JWSTransactionDecodedPayload.transactionId,
                \JWSTransactionDecodedPayload.webOrderLineItemId,
                \JWSTransactionDecodedPayload.bundleId,
                \JWSTransactionDecodedPayload.productId,
                \JWSTransactionDecodedPayload.subscriptionGroupIdentifier,
                \JWSTransactionDecodedPayload.offerIdentifier,
                \JWSTransactionDecodedPayload.storefront,
                \JWSTransactionDecodedPayload.storefrontId,
                \JWSTransactionDecodedPayload.currency,
            ]
            let dateKeyPaths = [
                \JWSTransactionDecodedPayload.purchaseDate,
                \JWSTransactionDecodedPayload.originalPurchaseDate,
                \JWSTransactionDecodedPayload.expiresDate,
                \JWSTransactionDecodedPayload.signedDate,
                \JWSTransactionDecodedPayload.revocationDate,
            ]
            let int64KeyPaths = [
                \JWSTransactionDecodedPayload.quantity
            ]
            let int32KeyPaths = [
                \JWSTransactionDecodedPayload.price
            ]
            let boolKeyPaths = [
                \JWSTransactionDecodedPayload.isUpgraded
            ]
            let productTypeKeyPaths = [
                \JWSTransactionDecodedPayload.type
            ]
            let uuidKeyPaths = [
                \JWSTransactionDecodedPayload.appAccountToken
            ]
            let inAppOwnershipTypeKeyPaths = [
                \JWSTransactionDecodedPayload.inAppOwnershipType
            ]
            let revocationReasonKeyPaths = [
                \JWSTransactionDecodedPayload.revocationReason
            ]
            let offerTypeKeyPaths = [
                \JWSTransactionDecodedPayload.offerType
            ]
            let environmentKeyPaths = [
                \JWSTransactionDecodedPayload.environment
            ]
            let transactionReasonKeyPaths = [
                \JWSTransactionDecodedPayload.transactionReason
            ]
            let offerDiscountTypeKeyPaths = [
                \JWSTransactionDecodedPayload.offerDiscountType
            ]

            if let keyPath = stringKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath])
            } else if let keyPath = dateKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.formatted())
            } else if let keyPath = int64KeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.description)
            } else if let keyPath = int32KeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.description)
            } else if let keyPath = boolKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.description)
            } else if let keyPath = productTypeKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.rawValue)
            } else if let keyPath = uuidKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.uuidString)
            } else if let keyPath = inAppOwnershipTypeKeyPaths.first(where: {
                $0 == dataSource.keyPath
            }) {
                CellText(item[keyPath: keyPath]?.rawValue)
            } else if let keyPath = revocationReasonKeyPaths.first(where: {
                $0 == dataSource.keyPath
            }) {
                CellText(item[keyPath: keyPath]?.description)
            } else if let keyPath = offerTypeKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.description)
            } else if let keyPath = environmentKeyPaths.first(where: { $0 == dataSource.keyPath }) {
                CellText(item[keyPath: keyPath]?.rawValue)
            } else if let keyPath = transactionReasonKeyPaths.first(where: {
                $0 == dataSource.keyPath
            }) {
                Label {
                    CellText(item[keyPath: keyPath]?.rawValue)
                } icon: {
                    let eventIcon = item[keyPath: keyPath]?.eventIcon ?? "questionmark"
                    let eventColor = item[keyPath: keyPath]?.eventColor ?? .black
                    Image(systemName: eventIcon).foregroundStyle(eventColor).frame(width: iconSize)
                }
            } else if let keyPath = offerDiscountTypeKeyPaths.first(where: {
                $0 == dataSource.keyPath
            }) {
                CellText(item[keyPath: keyPath]?.rawValue)
            } else {
                Text("Unsupported Format")
            }
        }
        .width(ideal: dataSource.idealWidth)
    }

    var body: some View {
        Text(
            "(\(model.items.count) transactions x \(currentColumns.count) columns)"
        )
        .frame(
            maxWidth: .infinity, alignment: .leading
        ).padding(.horizontal)

        Table(of: JWSTransactionDecodedPayload.self) {
            TableColumnForEach(currentColumns) { currentColumn in
                column(dataSource: currentColumn)
            }
        } rows: {
            ForEach(model.items, content: TableRow.init)
        }
        .monospacedDigit()
        // This is workaround.
        // If you do not set the ID when deleting the first column, it will crash. Instead the animation dies...
        .id(UUID())
    }
}
