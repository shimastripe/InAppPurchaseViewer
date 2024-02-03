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

    private var state: LoadingViewState<TransactionHistory> {
        model.fetchTransactionHistoryState
    }

    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

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
                    TransactionHistoryTableView(model: transaction)

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
                                        Label("More notifications", systemImage: "arrowshape.down")
                                            .font(.title2)
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
                                        Label(
                                            "Retrieve all...",
                                            systemImage: "square.and.arrow.down.on.square.fill"
                                        ).font(.title2)
                                            .padding(8)
                                    }
                                    .help("Retrieves all History for a given period of time")
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
        .toolbar {
            ToolbarItem {
                HStack {
                    Text("Environment")
                    Picker("", selection: $model.environment) {
                        ForEach(ServerEnvironment.allCases) {
                            Text($0.description).tag($0)
                        }
                    }
                }
                .padding(8)
            }
            ToolbarItem {
                HStack {
                    Text("TransactionID").layoutPriority(1)
                    TextField("2000000123456789", text: $model.transactionID)
                }
                .padding(8)
            }
            ToolbarItem {
                HStack {
                    Text("StartDate")
                    TextField("", value: $model.transactionStartDate, formatter: Self.formatter)
                }
                .padding(8)
            }
            ToolbarItem {
                HStack {
                    Text("EndDate")
                    TextField("", value: $model.transactionEndDate, formatter: Self.formatter)
                }
                .padding(8)
            }
            ToolbarItem {
                Button {
                    Task {
                        await model.execute(action: .clearTransactionHistoryError)
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Retry")
            }
        }
        .onChange(of: model.environment) { _, _ in
            Task {
                await model.execute(action: .clearTransactionHistoryError)
            }
        }
        .textSelection(.enabled)
    }
}

#Preview {
    TransactionHistoryView()
}
