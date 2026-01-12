//
//  NotificationHistoryTableView.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import IAPInterface
import SwiftUI

struct NotificationHistoryTableView: View {

    let model: NotificationHistoryModel

    @Binding var columnCustomization: TableColumnCustomization<NotificationHistoryItem>

    let columnOrder: NotificationColumnOrder

    private var visibleColumns: [NotificationColumnID] {
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
        Text("(\(model.items.count) notifications x \(visibleColumnCount) columns)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

        Table(of: NotificationHistoryItem.self, columnCustomization: $columnCustomization) {
            TableColumnForEach(columnOrder.columns) { columnID in
                TableColumn(columnID.columnHeader) { item in
                    CellText(columnID.value(from: item))
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
