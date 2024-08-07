//
//  RevocationReason+.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import AppStoreServerLibrary

extension RevocationReason: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .refundedDueToIssue:
            "refundedDueToIssue"
        case .refundedForOtherReason:
            "refundedForOtherReason"
        }
    }
}
