//
//  NotificationHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import IAPInterface
import SwiftUI

struct NotificationHistoryTableView: View {

    @State private var isMoreTransactionInfo = false
    @State private var isDisplayedRenewalInfo = false

    private var columnCounts: Int {
        switch (isMoreTransactionInfo, isDisplayedRenewalInfo) {
        case (true, true):
            43
        case (true, false):
            24
        case (false, true):
            29
        case (false, false):
            10
        }
    }

    @ScaledMetric private var iconSize: CGFloat = 20

    let model: NotificationHistoryModel

    @TableColumnBuilder<NotificationHistoryItem, Never>
    var mainColumns: some TableColumnContent<NotificationHistoryItem, Never> {
        TableColumn("signedDate") {
            CellText($0.signedDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("notificationType") { item in
            Label {
                CellText(item.notificationType?.rawValue)
            } icon: {
                Image(systemName: item.eventIcon).foregroundStyle(item.eventColor)
                    .frame(width: iconSize)
            }
        }
        .width(ideal: 240)
        TableColumn("subType") {
            CellText($0.subType?.rawValue)
        }
        .width(ideal: 160)
        TableColumn("price") {
            CellText($0.transactionInfo?.price?.description)
        }
        .width(ideal: 60)
        TableColumn("currency") {
            CellText($0.transactionInfo?.currency)
        }
        .width(ideal: 60)
        TableColumn("originalTransactionID") {
            CellText($0.transactionInfo?.originalTransactionId)
        }
        .width(ideal: 140)
        TableColumn("transactionID") {
            CellText($0.transactionInfo?.transactionId)
        }
        .width(ideal: 140)
        TableColumn("originalPurchaseDate") {
            CellText($0.transactionInfo?.originalPurchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("purchaseDate") {
            CellText($0.transactionInfo?.purchaseDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("expiresDate") {
            CellText($0.transactionInfo?.expiresDate?.formatted())
        }
        .width(ideal: 120)
    }
    @TableColumnBuilder<NotificationHistoryItem, Never>
    var externalColumns: some TableColumnContent<NotificationHistoryItem, Never> {
        TableColumn("consumptionRequestReason") {
            CellText($0.consumptionRequestReason?.rawValue)
        }
        .width(ideal: 160)
        TableColumn("externalPurchaseId") {
            CellText($0.externalPurchaseToken?.externalPurchaseId)
        }
        .width(ideal: 120)
        TableColumn("tokenCreationDate") { item in
            CellText(
                item.externalPurchaseToken?.tokenCreationDate.map({
                    Date(timeIntervalSince1970: TimeInterval($0))
                })?.formatted())
        }
        .width(ideal: 120)
    }
    @TableColumnBuilder<NotificationHistoryItem, Never>
    var transactionColumns: some TableColumnContent<NotificationHistoryItem, Never> {
        TableColumn("notificationUUID") {
            Text("\($0.id.rawValue)")
        }
        TableColumn("transactionReason") {
            CellText($0.transactionInfo?.transactionReason?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("offerIdentifier") {
            CellText($0.transactionInfo?.offerIdentifier)
        }
        .width(ideal: 120)
        TableColumn("offerType") {
            CellText($0.transactionInfo?.offerType?.description)
        }
        .width(ideal: 120)
        TableColumn("offerDiscountType") {
            CellText($0.transactionInfo?.offerDiscountType?.rawValue)
        }
        .width(ideal: 120)
        TableColumn("appAccountToken") {
            CellText($0.transactionInfo?.appAccountToken?.uuidString)
        }
        .width(ideal: 120)
        TableColumn("bundleId") {
            CellText($0.transactionInfo?.bundleId)
        }
        .width(ideal: 140)
        TableColumn("productId") {
            CellText($0.transactionInfo?.productId)
        }
        .width(ideal: 140)
        TableColumn("subscriptionGroupIdentifier") {
            CellText($0.transactionInfo?.subscriptionGroupIdentifier)
        }
        .width(ideal: 160)
        TableColumn("quantity") {
            CellText($0.transactionInfo?.quantity?.description)
        }
        .width(ideal: 60)
    }

    @TableColumnBuilder<NotificationHistoryItem, Never>
    var transactionColumns2: some TableColumnContent<NotificationHistoryItem, Never> {
        TableColumn("type") {
            CellText($0.transactionInfo?.type?.rawValue)
        }
        .width(ideal: 180)
        TableColumn("inAppOwnershipType") {
            CellText($0.transactionInfo?.inAppOwnershipType?.rawValue)
        }
        .width(ideal: 160)
        TableColumn("environment") {
            CellText($0.transactionInfo?.environment?.rawValue)
        }
        .width(ideal: 80)
        TableColumn("storefront") {
            CellText($0.transactionInfo?.storefront)
        }
        .width(ideal: 60)
        TableColumn("storefrontId") {
            CellText($0.transactionInfo?.storefrontId)
        }
        .width(ideal: 80)
        TableColumn("webOrderLineItemId") {
            CellText($0.transactionInfo?.webOrderLineItemId)
        }
        .width(ideal: 140)
        TableColumn("revocationReason") {
            CellText($0.transactionInfo?.revocationReason?.description)
        }
        .width(ideal: 120)
        TableColumn("revocationDate") {
            CellText($0.transactionInfo?.revocationDate?.formatted())
        }
        .width(ideal: 120)
        TableColumn("isUpgraded") {
            CellText($0.transactionInfo?.isUpgraded?.description)
        }
        .width(ideal: 120)
        TableColumn("transaction signedDate") {
            CellText($0.transactionInfo?.signedDate?.formatted())
        }
        .width(ideal: 120)
    }

    @TableColumnBuilder<NotificationHistoryItem, Never>
    var renewalInfoColumns: some TableColumnContent<NotificationHistoryItem, Never> {
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

    @TableColumnBuilder<NotificationHistoryItem, Never>
    var renewalInfoColumns2: some TableColumnContent<NotificationHistoryItem, Never> {
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
            CellText($0.renewalInfo?.renewalPrice?.formatted())
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

        Text("(\(model.items.count) notifications x \(columnCounts) columns)").frame(
            maxWidth: .infinity, alignment: .leading
        ).padding(.horizontal)

        switch (isMoreTransactionInfo, isDisplayedRenewalInfo) {
        case (true, true):
            Table(of: NotificationHistoryItem.self) {
                mainColumns
                externalColumns
                transactionColumns
                transactionColumns2
                renewalInfoColumns
                renewalInfoColumns2
            } rows: {
                ForEach(model.items, content: TableRow.init)
            }
            .monospacedDigit()
        case (true, false):
            Table(of: NotificationHistoryItem.self) {
                mainColumns
                externalColumns
                transactionColumns
                transactionColumns2
            } rows: {
                ForEach(model.items, content: TableRow.init)
            }
            .monospacedDigit()
        case (false, true):
            Table(of: NotificationHistoryItem.self) {
                mainColumns
                externalColumns
                renewalInfoColumns
                renewalInfoColumns2
            } rows: {
                ForEach(model.items, content: TableRow.init)
            }
            .monospacedDigit()
        case (false, false):
            Table(of: NotificationHistoryItem.self) {
                mainColumns
                externalColumns
            } rows: {
                ForEach(model.items, content: TableRow.init)
            }
            .monospacedDigit()
        }
    }
}
