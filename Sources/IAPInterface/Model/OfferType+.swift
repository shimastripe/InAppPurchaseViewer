//
//  OfferType+.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import AppStoreServerLibrary  // For Model
import Foundation

public typealias OfferType = AppStoreServerLibrary.OfferType

extension OfferType: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .introductoryOffer:
            "introductoryOffer"
        case .promotionalOffer:
            "promotionalOffer"
        case .offerCode:
            "offerCode"
        case .winBackOffer:
            "winBackOffer"
        }
    }
}
