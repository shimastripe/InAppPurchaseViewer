//
//  NotificationFilterOption.swift
//  InAppPurchaseViewer
//
//  Created by Go TAKAGI on 2025/01/11.
//

import AppStoreServerLibrary

/// Represents a valid combination of NotificationType and optional Subtype for filtering.
/// Based on: https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
public struct NotificationFilterOption: Hashable, Identifiable, Sendable {
    public let notificationType: NotificationTypeV2
    public let subtype: Subtype?

    public var id: String {
        if let subtype {
            return "\(notificationType.rawValue)-\(subtype.rawValue)"
        }
        return notificationType.rawValue
    }

    public var displayName: String {
        if let subtype {
            return "\(notificationType.rawValue) - \(subtype.rawValue)"
        }
        return notificationType.rawValue
    }

    public init(_ notificationType: NotificationTypeV2, subtype: Subtype? = nil) {
        self.notificationType = notificationType
        self.subtype = subtype
    }
}

extension NotificationFilterOption {
    /// All valid combinations of NotificationType and Subtype.
    /// Only includes combinations explicitly documented.
    /// Reference: https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
    public static let allOptions: [NotificationFilterOption] = [
        // CONSUMPTION_REQUEST - no subtype
        .init(.consumptionRequest),

        // DID_CHANGE_RENEWAL_PREF - no subtype, DOWNGRADE, UPGRADE
        .init(.didChangeRenewalPref),
        .init(.didChangeRenewalPref, subtype: .downgrade),
        .init(.didChangeRenewalPref, subtype: .upgrade),

        // DID_CHANGE_RENEWAL_STATUS - no subtype, AUTO_RENEW_ENABLED, AUTO_RENEW_DISABLED
        .init(.didChangeRenewalStatus),
        .init(.didChangeRenewalStatus, subtype: .autoRenewEnabled),
        .init(.didChangeRenewalStatus, subtype: .autoRenewDisabled),

        // DID_FAIL_TO_RENEW - no subtype (billing retry period), GRACE_PERIOD
        .init(.didFailToRenew),
        .init(.didFailToRenew, subtype: .gracePeriod),

        // DID_RENEW - no subtype (normal renewal), BILLING_RECOVERY
        .init(.didRenew),
        .init(.didRenew, subtype: .billingRecovery),

        // EXPIRED - VOLUNTARY, BILLING_RETRY, PRICE_INCREASE, PRODUCT_NOT_FOR_SALE
        .init(.expired, subtype: .voluntary),
        .init(.expired, subtype: .billingRetry),
        .init(.expired, subtype: .priceIncrease),
        .init(.expired, subtype: .productNotForSale),

        // EXTERNAL_PURCHASE_TOKEN - UNREPORTED, SUMMARY
        .init(.externalPurchaseToken, subtype: .unreported),
        .init(.externalPurchaseToken, subtype: .summary),

        // GRACE_PERIOD_EXPIRED - no subtype
        .init(.gracePeriodExpired),

        // OFFER_REDEEMED - UPGRADE, DOWNGRADE
        .init(.offerRedeemed, subtype: .upgrade),
        .init(.offerRedeemed, subtype: .downgrade),

        // ONE_TIME_CHARGE - no subtype (successful), FAILURE
        .init(.oneTimeCharge),
        .init(.oneTimeCharge, subtype: .failure),

        // PRICE_INCREASE - PENDING, ACCEPTED
        .init(.priceIncrease, subtype: .pending),
        .init(.priceIncrease, subtype: .accepted),

        // REFUND - no subtype
        .init(.refund),

        // REFUND_DECLINED - no subtype
        .init(.refundDeclined),

        // REFUND_REVERSED - no subtype
        .init(.refundReversed),

        // RENEWAL_EXTENDED - no subtype, SUMMARY, FAILURE
        .init(.renewalExtended),
        .init(.renewalExtended, subtype: .summary),
        .init(.renewalExtended, subtype: .failure),

        // RENEWAL_EXTENSION - SUMMARY, FAILURE
        .init(.renewalExtension, subtype: .summary),
        .init(.renewalExtension, subtype: .failure),

        // REVOKE - no subtype
        .init(.revoke),

        // SUBSCRIBED - INITIAL_BUY, RESUBSCRIBE
        .init(.subscribed, subtype: .initialBuy),
        .init(.subscribed, subtype: .resubscribe),

        // TEST - no subtype
        .init(.test),
    ]
}
