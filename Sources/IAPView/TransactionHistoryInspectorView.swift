//
//  TransactionHistoryInspectorView.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/09/29.
//

import SwiftUI

struct TransactionHistoryInspectorView: View {

    @Binding var currentColumns: [IAPCellDataSource.TransactionDecodedPayload]

    var body: some View {
        List {
            Section(header: Text("transactionInfo")) {
                ForEach($currentColumns) { $item in
                    LabeledContent {
                        Image(systemName: "line.3.horizontal")
                    } label: {
                        HStack {
                            Toggle("", isOn: $item.isOn)
                            Text(item.name)
                        }
                    }
                    .opacity(item.isOn ? 1 : 0.5)
                }
                .onDelete(perform: { indexSet in
                    currentColumns.remove(atOffsets: indexSet)
                })
                .onMove(perform: { indices, newOffset in
                    currentColumns.move(fromOffsets: indices, toOffset: newOffset)
                })
            }
        }
        .listStyle(.sidebar)
    }
}
