//
//  TransactionInfoTableView.swift
//
//
//  Created by Claude on 2025/01/12.
//

import IAPInterface
import SwiftUI

struct TransactionInfoTableView: View {

    let transaction: JWSTransactionDecodedPayload

    @Binding var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>

    let columnOrder: TransactionColumnOrder

    @ScaledMetric private var iconSize: CGFloat = 20

    private var visibleColumns: [TransactionColumnID] {
        columnOrder.columns.filter {
            columnCustomization[visibility: $0.rawValue] != .hidden
        }
    }

    private var visibleColumnCount: Int {
        visibleColumns.count
    }

    /// Stable ID for forcing Table rebuild when column visibility changes
    /// Uses sorted column IDs to be order-independent (preserves reorder animation)
    private var tableIdentifier: String {
        visibleColumns.map(\.rawValue).sorted().joined(separator: ",")
    }

    var body: some View {
        Text("(1 transaction x \(visibleColumnCount) columns)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

        Table(of: JWSTransactionDecodedPayload.self, columnCustomization: $columnCustomization) {
            TableColumnForEach(columnOrder.columns) { columnID in
                TableColumn(columnID.displayName) { payload in
                    cellContent(for: columnID, payload: payload)
                }
                .width(min: columnID.width.rawValue, ideal: columnID.width.rawValue)
                .customizationID(columnID.rawValue)
            }
        } rows: {
            TableRow(transaction)
        }
        .monospacedDigit()
        .id(tableIdentifier)
    }

    @ViewBuilder
    private func cellContent(
        for columnID: TransactionColumnID, payload: JWSTransactionDecodedPayload
    ) -> some View {
        if let iconInfo = columnID.iconInfo(from: payload) {
            Label {
                CellText(columnID.value(from: payload))
            } icon: {
                Image(systemName: iconInfo.systemName)
                    .foregroundStyle(iconInfo.color)
                    .frame(width: iconSize)
            }
        } else {
            CellText(columnID.value(from: payload))
        }
    }
}
