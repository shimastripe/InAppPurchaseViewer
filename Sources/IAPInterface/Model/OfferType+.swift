//
//  OfferType+.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import AppStoreServerLibrary
import Foundation

extension OfferType: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .introductoryOffer:
            "introductoryOffer"
        case .promotionalOffer:
            "promotionalOffer"
        case .subscriptionOfferCode:
            "subscriptionOfferCode"
        case .winBackOffer:
            "winBackOffer"
        }
    }
}
