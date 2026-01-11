//
//  NotificationTypeV2+.swift
//  InAppPurchaseViewer
//
//  Created by Go TAKAGI on 2025/03/08.
//

import AppStoreServerLibrary  // For Model

public typealias NotificationTypeV2 = AppStoreServerLibrary.NotificationTypeV2

extension NotificationTypeV2: @retroactive CaseIterable {
    public static var allCases: [NotificationTypeV2] {
        [
            .subscribed,
            .didChangeRenewalPref,
            .didChangeRenewalStatus,
            .offerRedeemed,
            .didRenew,
            .expired,
            .didFailToRenew,
            .gracePeriodExpired,
            .priceIncrease,
            .refund,
            .refundDeclined,
            .consumptionRequest,
            .renewalExtended,
            .revoke,
            .test,
            .renewalExtension,
            .refundReversed,
            .externalPurchaseToken,
            .oneTimeCharge,
        ]
    }
}
