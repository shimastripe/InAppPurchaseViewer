//
//  NotificationHistoryItem+.swift
//
//
//  Created by shimastripe on 2024/02/11.
//

import SwiftUI

extension NotificationHistoryItem {

    public var eventIcon: String {
        switch (notificationType, subType) {
        case (.subscribed, .initialBuy), (.offerRedeemed, .initialBuy):
            return "play.fill"
        case (.subscribed, .resubscribe), (.offerRedeemed, .resubscribe):
            return "memories"
        case (.didRenew, nil), (.didChangeRenewalPref, .upgrade), (.renewalExtended, _),
            (.renewalExtension, _),
            (.priceIncrease, .accepted):
            return "arrow.triangle.2.circlepath"
        case (.didChangeRenewalPref, .downgrade), (.didChangeRenewalPref, nil),
            (.didChangeRenewalStatus, .autoRenewEnabled),
            (.didChangeRenewalStatus, .autoRenewDisabled):
            return "shuffle"
        case (.didFailToRenew, .gracePeriod):
            return "clock.badge.exclamationmark"
        case (.gracePeriodExpired, nil), (.didFailToRenew, nil):
            return "clock.badge.xmark"
        case (.didRenew, .billingRecovery):
            return "clock.badge.checkmark"
        case (.priceIncrease, .pending):
            return "signature"
        case (.revoke, _), (.expired, .voluntary), (.expired, .priceIncrease),
            (.expired, .billingRetry):
            return "slash.circle"
        case (.consumptionRequest, _):
            return "person.fill.questionmark"
        case (.refund, _):
            return "dollarsign.arrow.circlepath"
        case (.refundDeclined, _):
            return "exclamationmark.arrow.circlepath"
        case (.refundReversed, _):
            return "exclamationmark.arrow.triangle.2.circlepath"
        case (.externalPurchaseToken, .unreported):
            return "creditcard.fill"
        case (.oneTimeCharge, _):
            return "cart.circle.fill"
        case (.test, _):
            return "hammer"
        default:
            assertionFailure("Unexpected")
            return "questionmark"
        }
    }

    public var eventColor: Color {
        switch (notificationType, subType) {
        case (.subscribed, _), (.offerRedeemed, _), (.didRenew, _), (.renewalExtended, _),
            (.renewalExtension, .summary), (.didChangeRenewalPref, .upgrade), (.refundReversed, _),
            (.oneTimeCharge, _):
            return .green
        case (.didFailToRenew, .gracePeriod):
            return .blue
        case (.didChangeRenewalPref, .downgrade), (.didChangeRenewalPref, nil),
            (.didChangeRenewalStatus, _), (.didFailToRenew, _),
            (.gracePeriodExpired, _):
            return .yellow
        case (.expired, _), (.revoke, _), (.renewalExtension, .failure), (.refundDeclined, _):
            return .red
        case (.priceIncrease, _):
            return .purple
        case (.consumptionRequest, _), (.refund, _):
            return .mint
        case (.externalPurchaseToken, .unreported):
            return .indigo
        case (.test, _):
            return .cyan
        default:
            assertionFailure("Unexpected")
            return .black
        }
    }
}
