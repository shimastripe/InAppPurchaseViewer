//
//  ExpirationIntent+.swift
//
//
//  Created by shimastripe on 2024/02/20.
//

import AppStoreServerLibrary  // For Model
import Foundation

public typealias ExpirationIntent = AppStoreServerLibrary.ExpirationIntent

extension ExpirationIntent: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .customerCancelled:
            "customerCancelled"
        case .billingError:
            "billingError"
        case .customerDidNotConsentToPriceIncrease:
            "customerDidNotConsentToPriceIncrease"
        case .productNotAvailable:
            "productNotAvailable"
        case .other:
            "other"
        }
    }
}
