//
//  Status+.swift
//
//
//  Created by shimastripe on 2024/02/13.
//

import AppStoreServerLibrary
import SwiftUI

extension Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active:
            "active"
        case .billingGracePeriod:
            "billingGracePeriod"
        case .billingRetry:
            "billingRetry"
        case .expired:
            "expired"
        case .revoked:
            "revoked"
        }
    }

    public var eventIcon: String {
        switch self {
        case .active:
            "play.fill"
        case .billingGracePeriod:
            "clock.badge.exclamationmark"
        case .billingRetry, .expired, .revoked:
            "slash.circle"
        }
    }

    public var eventColor: Color {
        switch self {
        case .active:
            .green
        case .billingGracePeriod:
            .blue
        case .billingRetry:
            .yellow
        case .expired, .revoked:
            .red
        }
    }
}
