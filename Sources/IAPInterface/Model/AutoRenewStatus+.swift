//
//  AutoRenewStatus+.swift
//
//
//  Created by shimastripe on 2024/02/20.
//

import AppStoreServerLibrary  // For Model
import Foundation

public typealias AutoRenewStatus = AppStoreServerLibrary.AutoRenewStatus

extension AutoRenewStatus: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .off:
            "off"
        case .on:
            "on"
        }
    }
}
