//
//  SubscriptionStatusTableView.swift
//
//
//  Created by shimastripe on 2024/02/23.
//

import IAPInterface
import SwiftUI

struct SubscriptionStatusTableView: View {

    let model: SubscriptionStatus

    @Binding var columnCustomization: TableColumnCustomization<LastTransaction>

    let columnOrder: SubscriptionColumnOrder

    @ScaledMetric private var iconSize: CGFloat = 20

    private var visibleColumns: [SubscriptionColumnID] {
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
        let items: [LastTransaction] = Array(model.items.map(\.items).joined())

        Text("(\(items.count) subscription groups x \(visibleColumnCount) columns)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

        Table(of: LastTransaction.self, columnCustomization: $columnCustomization) {
            TableColumnForEach(columnOrder.columns) { columnID in
                TableColumn(columnID.columnHeader) { item in
                    cellContent(for: columnID, item: item)
                }
                .width(min: columnID.width.rawValue, ideal: columnID.width.rawValue)
                .customizationID(columnID.rawValue)
            }
        } rows: {
            ForEach(items, content: TableRow.init)
        }
        .monospacedDigit()
        .id(tableIdentifier)
    }

    @ViewBuilder
    private func cellContent(for columnID: SubscriptionColumnID, item: LastTransaction) -> some View
    {
        if let iconInfo = columnID.iconInfo(from: item) {
            Label {
                CellText(columnID.value(from: item))
            } icon: {
                Image(systemName: iconInfo.systemName)
                    .foregroundStyle(iconInfo.color)
                    .frame(width: iconSize)
            }
        } else {
            CellText(columnID.value(from: item))
        }
    }
}
