//
//  TransactionColumnInspectorView.swift
//
//
//  Created by Claude on 2025/01/11.
//

import IAPInterface
import SwiftUI

struct TransactionColumnInspectorView: View {

    @Binding var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>
    @Binding var columnOrder: TransactionColumnOrder

    var body: some View {
        List {
            Section {
                HStack {
                    Button("Show All") {
                        showAllColumns()
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button("Hide All") {
                        hideAllColumns()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.vertical, 4)
            }

            Section("Columns") {
                ForEach(columnOrder.columns) { columnID in
                    ColumnToggleRow(
                        columnID: columnID,
                        columnCustomization: $columnCustomization
                    )
                }
                .onMove { from, to in
                    columnOrder.columns.move(fromOffsets: from, toOffset: to)
                }
            }

            Section {
                Button("Reset Order") {
                    resetColumnOrder()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(.sidebar)
    }

    private func showAllColumns() {
        for columnID in TransactionColumnID.allCases {
            columnCustomization[visibility: columnID.rawValue] = .visible
        }
    }

    private func hideAllColumns() {
        for columnID in TransactionColumnID.allCases {
            columnCustomization[visibility: columnID.rawValue] = .hidden
        }
    }

    private func resetColumnOrder() {
        columnOrder.columns = Array(TransactionColumnID.allCases)
    }
}

private struct ColumnToggleRow: View {
    let columnID: TransactionColumnID
    @Binding var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>

    private var isVisible: Bool {
        columnCustomization[visibility: columnID.rawValue] != .hidden
    }

    var body: some View {
        LabeledContent {
            Toggle(
                "",
                isOn: Binding(
                    get: { isVisible },
                    set: { newValue in
                        columnCustomization[visibility: columnID.rawValue] =
                            newValue ? .visible : .hidden
                    }
                )
            )
            .labelsHidden()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.secondary)
                linkLabel
            }
        }
    }

    @ViewBuilder
    private var linkLabel: some View {
        let link = Link(columnID.displayName, destination: columnID.documentationURL)
            .foregroundStyle(isVisible ? Color.accentColor : Color.secondary)
            .underline(isVisible)
            .help(columnID.documentationURL.absoluteString)

        if #available(macOS 15.0, *) {
            link.pointerStyle(.link)
        } else {
            link
        }
    }
}
