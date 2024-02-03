//
//  NotificationHistoryItem+.swift
//
//
//  Created by shimastripe on 2024/02/11.
//

import AppStoreServerLibrary
import SwiftUI

extension NotificationHistoryItem {

    public var eventIcon: String {
        switch (notificationType, subType) {
        case (.subscribed, .initialBuy), (.offerRedeemed, .initialBuy):
            return "play.fill"
        case (.subscribed, .resubscribe), (.offerRedeemed, .resubscribe):
            return "memories"
        case (.didRenew, nil), (.didChangeRenewalPref, .upgrade), (.renewalExtended, _),
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
            (.renewalExtension, _), (.didChangeRenewalPref, .upgrade):
            return .green
        case (.didFailToRenew, .gracePeriod):
            return .blue
        case (.didChangeRenewalPref, .downgrade), (.didChangeRenewalPref, nil),
            (.didChangeRenewalStatus, _), (.didFailToRenew, _),
            (.gracePeriodExpired, _):
            return .yellow
        case (.expired, _), (.revoke, _):
            return .red
        case (.priceIncrease, _):
            return .purple
        case (.consumptionRequest, _), (.refund, _), (.refundDeclined, _), (.refundReversed, _):
            return .mint
        case (.test, _):
            return .cyan
        default:
            assertionFailure("Unexpected")
            return .black
        }
    }
}
