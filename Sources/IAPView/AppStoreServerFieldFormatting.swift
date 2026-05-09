//
//  AppStoreServerFieldFormatting.swift
//
//
//  Created by Codex on 2026/05/09.
//

import IAPInterface

extension JWSTransactionDecodedPayload {
    var commitmentBillingPeriodNumberDescription: String? {
        commitmentInfo?.billingPeriodNumber?.description
    }

    var commitmentTotalBillingPeriodsDescription: String? {
        commitmentInfo?.totalBillingPeriods?.description
    }

    var commitmentExpiresDateDescription: String? {
        commitmentInfo?.commitmentExpiresDate?.formatted()
    }

    var commitmentPriceDescription: String? {
        commitmentInfo?.commitmentPrice?.description
    }
}

extension JWSRenewalInfoDecodedPayload {
    var commitmentAutoRenewStatusDescription: String? {
        commitmentInfo?.commitmentAutoRenewStatus?.description
    }

    var commitmentRenewalDateDescription: String? {
        commitmentInfo?.commitmentRenewalDate?.formatted()
    }

    var commitmentRenewalPriceDescription: String? {
        commitmentInfo?.commitmentRenewalPrice?.description
    }

    var advancedCommercePriceIncreaseInfoDependentSKUDescription: String? {
        let values =
            advancedCommerceInfo?.items?
            .compactMap { $0.priceIncreaseInfo?.dependentSKUs }
            .flatMap { $0 } ?? []
        return values.joinedIfNotEmpty
    }

    var advancedCommercePriceIncreaseInfoStatusDescription: String? {
        let values =
            advancedCommerceInfo?.items?
            .compactMap { $0.priceIncreaseInfo?.status?.rawValue } ?? []
        return values.joinedIfNotEmpty
    }

    var advancedCommercePriceIncreaseInfoPriceDescription: String? {
        let values =
            advancedCommerceInfo?.items?
            .compactMap { $0.priceIncreaseInfo?.price?.description } ?? []
        return values.joinedIfNotEmpty
    }
}

extension Array where Element == String {
    fileprivate var joinedIfNotEmpty: String? {
        isEmpty ? nil : joined(separator: ", ")
    }
}
