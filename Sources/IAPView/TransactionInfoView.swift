//
//  TransactionInfoView.swift
//
//
//  Created by Claude on 2025/01/12.
//

import IAPInterface
import IAPModel
import SwiftUI

struct TransactionInfoView: View {

    @Environment(IAPModel.self)
    private var model

    @SceneStorage("TransactionInfoColumnCustomization")
    private var columnCustomization: TableColumnCustomization<JWSTransactionDecodedPayload>

    @SceneStorage("TransactionInfoColumnOrder")
    private var columnOrder: TransactionColumnOrder = .init()

    @State private var isInspectorPresented = false

    private var state: LoadingViewState<JWSTransactionDecodedPayload> {
        model.fetchTransactionInfoState
    }

    var body: some View {
        @Bindable var model = model

        mainContent(model: model)
            .toolbar { toolbarContent(bindableModel: $model) }
            .inspector(isPresented: $isInspectorPresented) {
                TransactionColumnInspectorView(
                    columnCustomization: $columnCustomization,
                    columnOrder: $columnOrder
                )
                .inspectorColumnWidth(min: 200, ideal: 280, max: 400)
            }
            .onChange(of: model.environment) { _, _ in
                Task {
                    await model.execute(action: .clearTransactionInfoError)
                }
            }
            .onChange(of: model.transactionInfoTransactionID) { (oldValue, newValue) in
                guard oldValue != newValue, !oldValue.isEmpty else { return }
                model.isTransactionInfoStaledParameters = true
            }
            .onSubmit {
                Task {
                    model.isTransactionInfoStaledParameters = false
                    await model.execute(action: .clearTransactionInfoError)
                }
            }
            .textSelection(.enabled)
    }

    @ViewBuilder
    private func mainContent(model: IAPModel) -> some View {
        VStack {
            HStack {
                VStack(spacing: 12) {
                    Text("Get Transaction Info")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "Get information about a single transaction for your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_info)"
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                Image(systemName: "doc.text.magnifyingglass").font(.largeTitle).scenePadding()
            }
            .padding()
            Divider().padding(.horizontal)

            VStack {
                if let error = state.presentsError {
                    VStack {
                        Text("\(error.localizedDescription)")
                        Button("Retry") {
                            Task {
                                await model.execute(action: .clearTransactionInfoError)
                            }
                        }
                    }
                } else if let transaction = state.value {
                    TransactionInfoTableView(
                        transaction: transaction,
                        columnCustomization: $columnCustomization,
                        columnOrder: columnOrder
                    )
                } else {
                    if model.transactionInfoTransactionID.isEmpty {
                        Text("Enter TransactionID ⤴").font(.largeTitle)
                    } else {
                        ProgressView("Fetch App Store API...")
                            .task {
                                await model.execute(
                                    action: .fetchTransactionInfo(
                                        transactionID: model.transactionInfoTransactionID
                                    ))
                            }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent(bindableModel: Bindable<IAPModel>) -> some ToolbarContent {
        ToolbarItem {
            Picker("", selection: bindableModel.environment) {
                ForEach(ServerEnvironment.allCases) {
                    Label("\($0.description)", systemImage: $0.symbol)
                        .labelStyle(.titleAndIcon)
                        .tint($0.symbolColor)
                        .tag($0)
                }
            }
        }
        toolbarSpacer()
        ToolbarItem {
            TextField("TransactionID...", text: bindableModel.transactionInfoTransactionID)
                .frame(idealWidth: 136)
        }
        toolbarSpacer()
        ToolbarItem {
            Button {
                Task {
                    bindableModel.wrappedValue.isTransactionInfoStaledParameters = false
                    await bindableModel.wrappedValue.execute(action: .clearTransactionInfoError)
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .bold()
                    .foregroundStyle(
                        bindableModel.wrappedValue.isTransactionInfoStaledParameters
                            ? .orange : .primary)
            }
            .help("Retry")
        }
        toolbarSpacer()
        ToolbarItem(placement: .primaryAction) {
            Button {
                isInspectorPresented.toggle()
            } label: {
                Label("Columns", systemImage: "sidebar.right")
            }
            .help("Toggle column settings")
        }
    }
}

#Preview {
    TransactionInfoView()
}
