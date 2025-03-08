//
//  TransactionReason+.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import AppStoreServerLibrary  // For Model
import Foundation
import SwiftUI

public typealias TransactionReason = AppStoreServerLibrary.TransactionReason

extension TransactionReason {

    public var eventIcon: String {
        switch self {
        case .purchase:
            "play.fill"
        case .renewal:
            "memories"
        }
    }

    public var eventColor: Color {
        switch self {
        case .purchase:
            .green
        case .renewal:
            .teal
        }
    }
}
