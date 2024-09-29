//
//  IAPCellDataSource.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/09/29.
//

import Foundation
import IAPInterface

struct IAPCellDataSource: Sendable {
    struct TransactionDecodedPayload: Sendable, Identifiable {
        let keyPath: PartialKeyPath<JWSTransactionDecodedPayload> & Sendable
        let name: String
        let idealWidth: CGFloat
        var isOn: Bool

        var id: PartialKeyPath<JWSTransactionDecodedPayload> & Sendable { keyPath }
    }
}
