//
//  SubscriptionStatusTableView.swift
//
//
//  Created by shimastripe on 2024/02/23.
//

import IAPInterface
import SwiftUI

struct SubscriptionStatusTableView: View {

    @State private var isMoreTransactionInfo = false
    @State private var isDisplayedRenewalInfo = false

    private var columnCounts: Int {
        switch (isMoreTransactionInfo, isDisplayedRenewalInfo) {
        case (true, true):
            41
        case (true, false):
            27
        case (false, true):
            23
        case (false, false):
            9
        }
    }

    @ScaledMetric private var iconSize: CGFloat = 20

    let model: SubscriptionStatus

    @TableColumnBuilder<LastTransaction, Never>
    var mainColumns: some TableColumnContent<LastTransaction, Never> {
        TableColumn("subscriptionGroupIdentifier") {
            CellText($0.transaction?.subscriptionGroupIdentifier)
        }
        .width(ideal: 160)
        TableColumn("status") { item in
            Label {
                CellText(item.status?.description)
            } icon: {
                let eventIcon = item.status?.eventIcon ?? "questionmark"
                let eventColor = item.status?.eventColor ?? .black
                Image(systemName: eventIcon).foregroundStyle(eventColor).frame(width: iconSize)
            }
        }
        .width(ideal: 160)
        TableColumn("price") {
            CellText($0.transaction?.price?.description)
        }
        .width(ideal: 60)
        TableColumn("currency") {
            CellText($0.transaction?.currency)
        }
        .width(ideal: 60)
        TableColumn("originalTransactionID") {
            CellText($0.transaction?.originalTransactionId)
        }
        .width(ideal: 140)
        TableColumn("transactionID") {
            CellText($0.transaction?.transactionId)
        }
        .width(ideal: 140)
        TableColumn("originalPurchaseDate") {
            CellText($0.transaction?.originalPurchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("purchaseDate") {
            CellText($0.transaction?.purchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("expiresDate") {
            CellText($0.transaction?.expiresDate?.formatted())
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<LastTransaction, Never>
    var transactionColumns: some TableColumnContent<LastTransaction, Never> {
        TableColumn("transactionReason") {
            CellText($0.transaction?.transactionReason?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("offerIdentifier") {
            CellText($0.transaction?.offerIdentifier)
        }
        .width(ideal: 120)
        TableColumn("offerType") {
            CellText($0.transaction?.offerType?.description)
        }
        .width(ideal: 120)
        TableColumn("offerDiscountType") {
            CellText($0.transaction?.offerDiscountType?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("appAccountToken") {
            CellText($0.transaction?.appAccountToken?.uuidString)
        }
        .width(ideal: 120)
        TableColumn("bundleId") {
            CellText($0.transaction?.bundleId)
        }
        .width(ideal: 140)
        TableColumn("productId") {
            CellText($0.transaction?.productId)
        }
        .width(ideal: 140)
        TableColumn("quantity") {
            CellText($0.transaction?.quantity?.description)
        }
        .width(ideal: 60)
    }

    @TableColumnBuilder<LastTransaction, Never>
    var transactionColumns2: some TableColumnContent<LastTransaction, Never> {
        TableColumn("type") {
            CellText($0.transaction?.type?.rawValue)
        }
        .width(ideal: 180)
        TableColumn("inAppOwnershipType") {
            CellText($0.transaction?.inAppOwnershipType?.rawValue)
        }
        .width(ideal: 160)
        TableColumn("environment") {
            CellText($0.transaction?.environment?.rawValue)
        }
        .width(ideal: 80)
        TableColumn("storefront") {
            CellText($0.transaction?.storefront)
        }
        .width(ideal: 60)
        TableColumn("storefrontId") {
            CellText($0.transaction?.storefrontId)
        }
        .width(ideal: 80)
        TableColumn("webOrderLineItemId") {
            CellText($0.transaction?.webOrderLineItemId)
        }
        .width(ideal: 140)
        TableColumn("revocationReason") {
            CellText($0.transaction?.revocationReason?.description)
        }
        .width(ideal: 120)
        TableColumn("revocationDate") {
            CellText($0.transaction?.revocationDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("isUpgraded") {
            CellText($0.transaction?.isUpgraded?.description)
        }
        .width(ideal: 120)
        TableColumn("transaction signedDate") {
            CellText($0.transaction?.signedDate?.formatted())
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<LastTransaction, Never>
    var renewalInfoColumns: some TableColumnContent<LastTransaction, Never> {
        TableColumn("expirationIntent") {
            CellText($0.renewalInfo?.expirationIntent?.description)
        }
        .width(ideal: 120)
        TableColumn("originalTransactionId") {
            CellText($0.renewalInfo?.originalTransactionId)
        }
        .width(ideal: 120)
        TableColumn("autoRenewProductId") {
            CellText($0.renewalInfo?.autoRenewProductId)
        }
        .width(ideal: 120)
        TableColumn("productId") {
            CellText($0.renewalInfo?.productId)
        }
        .width(ideal: 120)
        TableColumn("autoRenewStatus") {
            CellText($0.renewalInfo?.autoRenewStatus?.description)
        }
        .width(ideal: 120)
        TableColumn("isInBillingRetryPeriod") {
            CellText($0.renewalInfo?.isInBillingRetryPeriod?.description)
        }
        .width(ideal: 120)
        TableColumn("priceIncreaseStatus") {
            CellText($0.renewalInfo?.priceIncreaseStatus?.description)
        }
        .width(ideal: 120)
        TableColumn("gracePeriodExpiresDate") {
            CellText($0.renewalInfo?.gracePeriodExpiresDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("offerType") {
            CellText($0.renewalInfo?.offerType?.description)
        }
        .width(ideal: 120)
        TableColumn("offerIdentifier") {
            CellText($0.renewalInfo?.offerIdentifier)
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<LastTransaction, Never>
    var renewalInfoColumns2: some TableColumnContent<LastTransaction, Never> {
        TableColumn("renewalInfo signedDate") {
            CellText($0.renewalInfo?.signedDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("environment") {
            CellText($0.renewalInfo?.environment?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("recentSubscriptionStartDate") {
            CellText($0.renewalInfo?.recentSubscriptionStartDate?.formatted())
        }
        .width(ideal: 160)
        TableColumn("renewalDate") {
            CellText($0.renewalInfo?.renewalDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("renewalPrice") {
            CellText($0.renewalInfo?.renewalPrice?.description)
        }
        .width(ideal: 120)
        TableColumn("currency") {
            CellText($0.renewalInfo?.currency)
        }
        .width(ideal: 120)
        TableColumn("offerDiscountType") {
            CellText($0.renewalInfo?.offerDiscountType?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("eligibleWinBackOfferIds") {
            CellText($0.renewalInfo?.eligibleWinBackOfferIds?.joined(separator: ", "))
        }
        .width(ideal: 120)
        TableColumn("appTransactionId") {
            CellText($0.renewalInfo?.appTransactionId)
        }
        .width(ideal: 120)
        TableColumn("offerPeriod") {
            CellText($0.renewalInfo?.offerPeriod)
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<LastTransaction, Never>
    var renewalInfoColumns3: some TableColumnContent<LastTransaction, Never> {
        TableColumn("appAccountToken") {
            CellText($0.renewalInfo?.appAccountToken?.uuidString)
        }
        .width(ideal: 120)
    }

    var body: some View {
        GroupBox {
            HStack {
                Toggle(isOn: $isMoreTransactionInfo) {
                    Text("Add full transaction columns")
                }
                .padding()
                Toggle(isOn: $isDisplayedRenewalInfo) {
                    Text("Add renewal information columns")
                }
                .padding()
            }
        }
        .padding()

        let items: [LastTransaction] = Array(model.items.map(\.items).joined())

        Text("(\(items.count) subscription groups x \(columnCounts) columns)").frame(
            maxWidth: .infinity, alignment: .leading
        ).padding(.horizontal)

        switch (isMoreTransactionInfo, isDisplayedRenewalInfo) {
        case (true, true):
            Table(of: LastTransaction.self) {
                mainColumns
                transactionColumns
                transactionColumns2
                renewalInfoColumns
                renewalInfoColumns2
                renewalInfoColumns3
            } rows: {
                ForEach(items, content: TableRow.init)
            }
            .monospacedDigit()
        case (true, false):
            Table(of: LastTransaction.self) {
                mainColumns
                transactionColumns
                transactionColumns2
            } rows: {
                ForEach(items, content: TableRow.init)
            }
            .monospacedDigit()
        case (false, true):
            Table(of: LastTransaction.self) {
                mainColumns
                renewalInfoColumns
                renewalInfoColumns2
                renewalInfoColumns3
            } rows: {
                ForEach(items, content: TableRow.init)
            }
            .monospacedDigit()
        case (false, false):
            Table(of: LastTransaction.self) {
                mainColumns
            } rows: {
                ForEach(items, content: TableRow.init)
            }
            .monospacedDigit()
        }
    }
}
