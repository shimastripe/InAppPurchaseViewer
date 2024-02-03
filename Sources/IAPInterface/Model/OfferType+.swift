//
//  OfferType+.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import AppStoreServerLibrary
import Foundation

extension OfferType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .introductoryOffer:
            "introductoryOffer"
        case .promotionalOffer:
            "promotionalOffer"
        case .subscriptionOfferCode:
            "subscriptionOfferCode"
        }
    }
}
