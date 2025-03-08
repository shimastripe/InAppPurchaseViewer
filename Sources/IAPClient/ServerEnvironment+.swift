//
//  ServerEnvironment+.swift
//
//
//  Created by shimastripe on 2024/02/18.
//

import AppStoreServerLibrary
import Foundation
import IAPInterface

extension ServerEnvironment {
    public var toModel: AppStoreEnvironment {
        switch self {
        case .sandbox:
            .sandbox
        case .production:
            .production
        }
    }
}
