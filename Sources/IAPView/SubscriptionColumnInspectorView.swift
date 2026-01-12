//
//  SubscriptionColumnInspectorView.swift
//
//
//  Created by Claude on 2025/01/12.
//

import IAPInterface
import SwiftUI

struct SubscriptionColumnInspectorView: View {

    @Binding var columnCustomization: TableColumnCustomization<LastTransaction>
    @Binding var columnOrder: SubscriptionColumnOrder

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
                    SubscriptionColumnToggleRow(
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
        for columnID in SubscriptionColumnID.allCases {
            columnCustomization[visibility: columnID.rawValue] = .visible
        }
    }

    private func hideAllColumns() {
        for columnID in SubscriptionColumnID.allCases {
            columnCustomization[visibility: columnID.rawValue] = .hidden
        }
    }

    private func resetColumnOrder() {
        columnOrder.columns = Array(SubscriptionColumnID.allCases)
    }
}

private struct SubscriptionColumnToggleRow: View {
    let columnID: SubscriptionColumnID
    @Binding var columnCustomization: TableColumnCustomization<LastTransaction>

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
        let link = Link(columnID.columnHeader, destination: columnID.documentationURL)
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
