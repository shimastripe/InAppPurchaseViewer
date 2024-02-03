//
//  PriceIncreaseStatus+.swift
//
//
//  Created by shimastripe on 2024/02/20.
//

import AppStoreServerLibrary
import Foundation

extension PriceIncreaseStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .customerHasNotResponded:
            "customerHasNotResponded"
        case .customerConsentedOrWasNotifiedWithoutNeedingConsent:
            "customerConsentedOrWasNotifiedWithoutNeedingConsent"
        }
    }
}
