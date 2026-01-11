//
//  TransactionHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import IAPInterface
import SwiftUI

struct TransactionHistoryTableView: View {

    let model: TransactionHistory

    @Binding var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>

    let columnOrder: TransactionColumnOrder

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
        Text("(\(model.items.count) transactions x \(visibleColumnCount) columns)")
            .frame(
                maxWidth: .infinity, alignment: .leading
            ).padding(.horizontal)

        Table(of: JWSTransactionDecodedPayload.self, columnCustomization: $columnCustomization) {
            TableColumnForEach(columnOrder.columns) { columnID in
                TableColumn(columnID.displayName) { payload in
                    CellText(columnID.value(from: payload))
                }
                .width(min: columnID.width.rawValue, ideal: columnID.width.rawValue)
                .customizationID(columnID.rawValue)
            }
        } rows: {
            ForEach(model.items, content: TableRow.init)
        }
        .monospacedDigit()
        .id(tableIdentifier)
    }
}
