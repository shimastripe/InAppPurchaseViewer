//
//  TransactionHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import IAPInterface
import SwiftUI

struct TransactionHistoryTableView: View {

    private let columnCounts = 28

    @ScaledMetric private var iconSize: CGFloat = 20

    let model: TransactionHistory

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    var mainColumns: some TableColumnContent<JWSTransactionDecodedPayload, Never> {
        TableColumn("purchaseDate") {
            CellText($0.purchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("transactionReason") { item in
            Label {
                CellText(item.transactionReason?.rawValue)
            } icon: {
                let eventIcon = item.transactionReason?.eventIcon ?? "questionmark"
                let eventColor = item.transactionReason?.eventColor ?? .black
                Image(systemName: eventIcon).foregroundStyle(eventColor).frame(width: iconSize)
            }
        }
        .width(ideal: 160)
        TableColumn("price") {
            CellText($0.price?.description)
        }
        .width(ideal: 60)
        TableColumn("currency") {
            CellText($0.currency)
        }
        .width(ideal: 60)
        TableColumn("originalTransactionID") {
            CellText($0.originalTransactionId)
        }
        .width(ideal: 140)
        TableColumn("transactionID") {
            CellText($0.transactionId)
        }
        .width(ideal: 140)
        TableColumn("originalPurchaseDate") {
            CellText($0.originalPurchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("expiresDate") {
            CellText($0.expiresDate?.formatted())
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    var transactionColumns: some TableColumnContent<JWSTransactionDecodedPayload, Never> {
        TableColumn("offerIdentifier") {
            CellText($0.offerIdentifier)
        }
        .width(ideal: 120)
        TableColumn("offerType") {
            CellText($0.offerType?.description)
        }
        .width(ideal: 120)
        TableColumn("offerDiscountType") {
            CellText($0.offerDiscountType?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("appAccountToken") {
            CellText($0.appAccountToken?.uuidString)
        }
        .width(ideal: 120)
        TableColumn("bundleId") {
            CellText($0.bundleId)
        }
        .width(ideal: 140)
        TableColumn("productId") {
            CellText($0.productId)
        }
        .width(ideal: 140)
        TableColumn("subscriptionGroupIdentifier") {
            CellText($0.subscriptionGroupIdentifier)
        }
        .width(ideal: 160)
        TableColumn("quantity") {
            CellText($0.quantity?.description)
        }
        .width(ideal: 60)
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    var transactionColumns2: some TableColumnContent<JWSTransactionDecodedPayload, Never> {
        TableColumn("type") {
            CellText($0.type?.rawValue)
        }
        .width(ideal: 180)
        TableColumn("inAppOwnershipType") {
            CellText($0.inAppOwnershipType?.rawValue)
        }
        .width(ideal: 160)
        TableColumn("environment") {
            CellText($0.environment?.rawValue)
        }
        .width(ideal: 80)
        TableColumn("storefront") {
            CellText($0.storefront)
        }
        .width(ideal: 60)
        TableColumn("storefrontId") {
            CellText($0.storefrontId)
        }
        .width(ideal: 80)
        TableColumn("webOrderLineItemId") {
            CellText($0.webOrderLineItemId)
        }
        .width(ideal: 140)
        TableColumn("revocationReason") {
            CellText($0.revocationReason?.description)
        }
        .width(ideal: 120)
        TableColumn("revocationDate") {
            CellText($0.revocationDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("isUpgraded") {
            CellText($0.isUpgraded?.description)
        }
        .width(ideal: 120)
        TableColumn("transaction signedDate") {
            CellText($0.signedDate?.formatted())
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    var transactionColumns3: some TableColumnContent<JWSTransactionDecodedPayload, Never> {
        TableColumn("appTransactionId") {
            CellText($0.appTransactionId)
        }
        .width(ideal: 120)
        TableColumn("offerPeriod") {
            CellText($0.offerPeriod)
        }
        .width(ideal: 120)
    }

    var body: some View {
        Text("(\(model.items.count) transactions x \(columnCounts) columns)").frame(
            maxWidth: .infinity, alignment: .leading
        ).padding(.horizontal)

        Table(of: JWSTransactionDecodedPayload.self) {
            mainColumns
            transactionColumns
            transactionColumns2
            transactionColumns3
        } rows: {
            ForEach(model.items, content: TableRow.init)
        }
        .monospacedDigit()
    }
}
