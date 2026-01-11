//
//  Subtype+.swift
//  InAppPurchaseViewer
//
//  Created by Go TAKAGI on 2025/03/08.
//

import AppStoreServerLibrary  // For Model

public typealias Subtype = AppStoreServerLibrary.Subtype

extension Subtype: @retroactive CaseIterable {
    public static var allCases: [Subtype] {
        [
            .initialBuy,
            .resubscribe,
            .downgrade,
            .upgrade,
            .autoRenewEnabled,
            .autoRenewDisabled,
            .voluntary,
            .billingRetry,
            .priceIncrease,
            .gracePeriod,
            .pending,
            .accepted,
            .billingRecovery,
            .productNotForSale,
            .summary,
            .failure,
            .unreported,
        ]
    }
}
