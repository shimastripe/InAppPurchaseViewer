//
//  TransactionHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import IAPInterface
import SwiftUI

struct TransactionHistoryTableView: View {

    @ScaledMetric private var iconSize: CGFloat = 20

    let model: TransactionHistory

    @Binding var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>

    let columnOrder: TransactionColumnOrder

    private var visibleColumnCount: Int {
        TransactionColumnID.allCases.filter {
            columnCustomization[visibility: $0.rawValue] != .hidden
        }.count
    }

    var body: some View {
        Text("(\(model.items.count) transactions x \(visibleColumnCount) columns)")
            .frame(
                maxWidth: .infinity, alignment: .leading
            ).padding(.horizontal)

        // Use columnOrder to determine display order, but fallback to static definition
        // since SwiftUI Table columns are built at compile time
        Table(of: JWSTransactionDecodedPayload.self, columnCustomization: $columnCustomization) {
            tableColumns(for: columnOrder.columns)
        } rows: {
            ForEach(model.items, content: TableRow.init)
        }
        .monospacedDigit()
        .id(columnOrder)  // Force rebuild when order changes
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    private func tableColumns(for order: [TransactionColumnID])
        -> some TableColumnContent<JWSTransactionDecodedPayload, Never>
    {
        // Split into groups of max 10 for TableColumnBuilder limits
        columnsGroup1(for: order)
        columnsGroup2(for: order)
        columnsGroup3(for: order)
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    private func columnsGroup1(for order: [TransactionColumnID])
        -> some TableColumnContent<JWSTransactionDecodedPayload, Never>
    {
        if order.count > 0 { columnView(for: order[0]) }
        if order.count > 1 { columnView(for: order[1]) }
        if order.count > 2 { columnView(for: order[2]) }
        if order.count > 3 { columnView(for: order[3]) }
        if order.count > 4 { columnView(for: order[4]) }
        if order.count > 5 { columnView(for: order[5]) }
        if order.count > 6 { columnView(for: order[6]) }
        if order.count > 7 { columnView(for: order[7]) }
        if order.count > 8 { columnView(for: order[8]) }
        if order.count > 9 { columnView(for: order[9]) }
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    private func columnsGroup2(for order: [TransactionColumnID])
        -> some TableColumnContent<JWSTransactionDecodedPayload, Never>
    {
        if order.count > 10 { columnView(for: order[10]) }
        if order.count > 11 { columnView(for: order[11]) }
        if order.count > 12 { columnView(for: order[12]) }
        if order.count > 13 { columnView(for: order[13]) }
        if order.count > 14 { columnView(for: order[14]) }
        if order.count > 15 { columnView(for: order[15]) }
        if order.count > 16 { columnView(for: order[16]) }
        if order.count > 17 { columnView(for: order[17]) }
        if order.count > 18 { columnView(for: order[18]) }
        if order.count > 19 { columnView(for: order[19]) }
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    private func columnsGroup3(for order: [TransactionColumnID])
        -> some TableColumnContent<JWSTransactionDecodedPayload, Never>
    {
        if order.count > 20 { columnView(for: order[20]) }
        if order.count > 21 { columnView(for: order[21]) }
        if order.count > 22 { columnView(for: order[22]) }
        if order.count > 23 { columnView(for: order[23]) }
        if order.count > 24 { columnView(for: order[24]) }
        if order.count > 25 { columnView(for: order[25]) }
        if order.count > 26 { columnView(for: order[26]) }
        if order.count > 27 { columnView(for: order[27]) }
    }

    @TableColumnBuilder<JWSTransactionDecodedPayload, Never>
    private func columnView(for columnID: TransactionColumnID)
        -> some TableColumnContent<JWSTransactionDecodedPayload, Never>
    {
        switch columnID {
        case .purchaseDate:
            TableColumn("purchaseDate") {
                CellText($0.purchaseDate?.formatted())
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.purchaseDate.rawValue)

        case .transactionReason:
            TableColumn("transactionReason") { item in
                Label {
                    CellText(item.transactionReason?.rawValue)
                } icon: {
                    let eventIcon = item.transactionReason?.eventIcon ?? "questionmark"
                    let eventColor = item.transactionReason?.eventColor ?? .black
                    Image(systemName: eventIcon).foregroundStyle(eventColor).frame(width: iconSize)
                }
            }
            .width(min: 160, ideal: 160)
            .customizationID(TransactionColumnID.transactionReason.rawValue)

        case .price:
            TableColumn("price") {
                CellText($0.price?.description)
            }
            .width(min: 60, ideal: 60)
            .customizationID(TransactionColumnID.price.rawValue)

        case .currency:
            TableColumn("currency") {
                CellText($0.currency)
            }
            .width(min: 60, ideal: 60)
            .customizationID(TransactionColumnID.currency.rawValue)

        case .originalTransactionID:
            TableColumn("originalTransactionID") {
                CellText($0.originalTransactionId)
            }
            .width(min: 140, ideal: 140)
            .customizationID(TransactionColumnID.originalTransactionID.rawValue)

        case .transactionID:
            TableColumn("transactionID") {
                CellText($0.transactionId)
            }
            .width(min: 140, ideal: 140)
            .customizationID(TransactionColumnID.transactionID.rawValue)

        case .appTransactionId:
            TableColumn("appTransactionId") {
                CellText($0.appTransactionId)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.appTransactionId.rawValue)

        case .originalPurchaseDate:
            TableColumn("originalPurchaseDate") {
                CellText($0.originalPurchaseDate?.formatted())
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.originalPurchaseDate.rawValue)

        case .expiresDate:
            TableColumn("expiresDate") {
                CellText($0.expiresDate?.formatted())
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.expiresDate.rawValue)

        case .offerIdentifier:
            TableColumn("offerIdentifier") {
                CellText($0.offerIdentifier)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.offerIdentifier.rawValue)

        case .offerType:
            TableColumn("offerType") {
                CellText($0.offerType?.description)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.offerType.rawValue)

        case .offerDiscountType:
            TableColumn("offerDiscountType") {
                CellText($0.offerDiscountType?.rawValue)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.offerDiscountType.rawValue)

        case .offerPeriod:
            TableColumn("offerPeriod") {
                CellText($0.offerPeriod)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.offerPeriod.rawValue)

        case .appAccountToken:
            TableColumn("appAccountToken") {
                CellText($0.appAccountToken?.uuidString)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.appAccountToken.rawValue)

        case .bundleId:
            TableColumn("bundleId") {
                CellText($0.bundleId)
            }
            .width(min: 140, ideal: 140)
            .customizationID(TransactionColumnID.bundleId.rawValue)

        case .productId:
            TableColumn("productId") {
                CellText($0.productId)
            }
            .width(min: 140, ideal: 140)
            .customizationID(TransactionColumnID.productId.rawValue)

        case .subscriptionGroupIdentifier:
            TableColumn("subscriptionGroupIdentifier") {
                CellText($0.subscriptionGroupIdentifier)
            }
            .width(min: 160, ideal: 160)
            .customizationID(TransactionColumnID.subscriptionGroupIdentifier.rawValue)

        case .quantity:
            TableColumn("quantity") {
                CellText($0.quantity?.description)
            }
            .width(min: 60, ideal: 60)
            .customizationID(TransactionColumnID.quantity.rawValue)

        case .type:
            TableColumn("type") {
                CellText($0.type?.rawValue)
            }
            .width(min: 180, ideal: 180)
            .customizationID(TransactionColumnID.type.rawValue)

        case .inAppOwnershipType:
            TableColumn("inAppOwnershipType") {
                CellText($0.inAppOwnershipType?.rawValue)
            }
            .width(min: 160, ideal: 160)
            .customizationID(TransactionColumnID.inAppOwnershipType.rawValue)

        case .environment:
            TableColumn("environment") {
                CellText($0.environment?.rawValue)
            }
            .width(min: 80, ideal: 80)
            .customizationID(TransactionColumnID.environment.rawValue)

        case .storefront:
            TableColumn("storefront") {
                CellText($0.storefront)
            }
            .width(min: 60, ideal: 60)
            .customizationID(TransactionColumnID.storefront.rawValue)

        case .storefrontId:
            TableColumn("storefrontId") {
                CellText($0.storefrontId)
            }
            .width(min: 80, ideal: 80)
            .customizationID(TransactionColumnID.storefrontId.rawValue)

        case .webOrderLineItemId:
            TableColumn("webOrderLineItemId") {
                CellText($0.webOrderLineItemId)
            }
            .width(min: 140, ideal: 140)
            .customizationID(TransactionColumnID.webOrderLineItemId.rawValue)

        case .revocationReason:
            TableColumn("revocationReason") {
                CellText($0.revocationReason?.description)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.revocationReason.rawValue)

        case .revocationDate:
            TableColumn("revocationDate") {
                CellText($0.revocationDate?.formatted())
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.revocationDate.rawValue)

        case .isUpgraded:
            TableColumn("isUpgraded") {
                CellText($0.isUpgraded?.description)
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.isUpgraded.rawValue)

        case .signedDate:
            TableColumn("signedDate") {
                CellText($0.signedDate?.formatted())
            }
            .width(min: 120, ideal: 120)
            .customizationID(TransactionColumnID.signedDate.rawValue)
        }
    }
}
