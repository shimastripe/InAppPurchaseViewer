//
//  TransactionHistoryView.swift
//
//
//  Created by shimastripe on 2024/02/24.
//

import IAPInterface
import IAPModel
import SwiftUI

struct TransactionHistoryView: View {

    @Environment(IAPModel.self)
    private var model
    @State private var isPresentedInspector = false
    @State var currentColumns: [IAPCellDataSource.TransactionDecodedPayload] = IAPCellDataSource
        .defaultTransactionInfo

    private var state: LoadingViewState<TransactionHistory> {
        model.fetchTransactionHistoryState
    }

    var body: some View {
        @Bindable var model = model

        VStack {
            HStack {
                VStack(spacing: 12) {
                    Text("Get Transaction History")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "Get a customer's in-app purchase transaction history for your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)"
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                Image(systemName: "flowchart").font(.largeTitle).scenePadding()
                Button("Edit") {
                    isPresentedInspector.toggle()
                }
                .padding(.trailing)
            }
            .padding()
            Divider().padding(.horizontal)

            VStack {
                if let error = state.presentsError {
                    VStack {
                        Text("\(error.localizedDescription)")
                        Button("Retry") {
                            Task {
                                await model.execute(action: .clearTransactionHistoryError)
                            }
                        }
                    }
                } else if let transaction = state.value {
                    TransactionHistoryTableView(
                        model: transaction,
                        currentColumns: $currentColumns.filter(\.isOn)
                    )

                    if let hasMore = transaction.hasMore, hasMore,
                        transaction.revision != nil
                    {
                        VStack {
                            ZStack {
                                ProgressView("Fetch App Store API...").opacity(
                                    !state.isAppendLoading ? 0 : 1)
                                HStack {
                                    Button {
                                        Task {
                                            await model.execute(
                                                action: .appendFetchTransactionHistory(
                                                    startDate: model.transactionStartDate,
                                                    endDate: model.transactionEndDate,
                                                    transactionID: model.transactionID))
                                        }
                                    } label: {
                                        Label("20", systemImage: "plus.app")
                                            .font(.title)
                                            .padding(8)
                                    }
                                    Button {
                                        Task {
                                            await model.execute(
                                                action: .bulkAppendFetchTransactionHistory(
                                                    startDate: model.transactionStartDate,
                                                    endDate: model.transactionEndDate,
                                                    transactionID: model.transactionID))
                                        }
                                    } label: {
                                        Label("200", systemImage: "plus.rectangle.on.rectangle")
                                            .font(.title)
                                            .padding(8)
                                    }
                                    .help("Retrieves 200 items for a given period of time")
                                }
                                .opacity(
                                    state.isAppendLoading ? 0 : 1)
                            }
                        }
                        .padding()
                    }
                } else {
                    if model.transactionID.isEmpty {
                        Text("Enter TransactionID ⤴").font(.largeTitle)
                    } else {
                        ProgressView("Fetch App Store API...")
                            .task {
                                await model.execute(
                                    action: .fetchTransactionHistory(
                                        startDate: model.transactionStartDate,
                                        endDate: model.transactionEndDate,
                                        transactionID: model.transactionID
                                    ))
                            }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .inspector(isPresented: $isPresentedInspector) {
            TransactionHistoryInspectorView(currentColumns: $currentColumns)
        }
        .toolbar {
            ToolbarItem {
                Picker("", selection: $model.environment) {
                    ForEach(ServerEnvironment.allCases) {
                        Label("\($0.description)", systemImage: $0.symbol)
                            .labelStyle(
                                .titleAndIcon
                            )
                            .tint($0.symbolColor)
                            .tag($0)
                    }
                }
            }
            toolbarSpacer()
            ToolbarItem {
                TextField("TransactionID...", text: $model.transactionID)
                    .frame(idealWidth: 136)
            }
            toolbarSpacer()
            ToolbarItem {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    TextField("", value: $model.transactionStartDate, format: .dateTime)
                    Text("〜")
                    TextField("", value: $model.transactionEndDate, format: .dateTime)
                }
            }
            toolbarSpacer()
            ToolbarItem {
                Button {
                    model.resetTransactionDates()
                } label: {
                    Image(systemName: "eraser").bold()
                }
            }
            toolbarSpacer()
            ToolbarItem {
                Button {
                    Task {
                        model.isStaledParameters = false
                        await model.execute(action: .clearTransactionHistoryError)
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .bold()
                        .foregroundStyle(model.isStaledParameters ? .orange : .primary)
                }
                .help("Retry")
            }
        }
        .onChange(of: model.environment) { _, _ in
            Task {
                await model.execute(action: .clearTransactionHistoryError)
            }
        }
        .onChange(of: model.transactionID) { (oldValue, newValue) in
            guard oldValue != newValue, !oldValue.isEmpty else { return }
            model.isStaledParameters = true
        }
        .onChange(of: [model.transactionStartDate, model.transactionEndDate]) {
            (oldValue, newValue) in
            guard oldValue != newValue else { return }
            model.isStaledParameters = true
        }
        .onSubmit {
            Task {
                model.isStaledParameters = false
                await model.execute(action: .clearTransactionHistoryError)
            }
        }
        .textSelection(.enabled)
    }
}

#Preview {
    TransactionHistoryView()
}
