//
//  SubscriptionStatusView.swift
//
//
//  Created by shimastripe on 2024/02/21.
//

import IAPInterface
import IAPModel
import SwiftUI

struct SubscriptionStatusView: View {

    @Environment(IAPModel.self)
    private var model

    @SceneStorage("SubscriptionStatusColumnCustomization")
    private var columnCustomization: TableColumnCustomization<LastTransaction>

    @SceneStorage("SubscriptionStatusColumnOrder")
    private var columnOrder: SubscriptionColumnOrder = .init()

    @State private var isInspectorPresented = false

    private var state: LoadingViewState<SubscriptionStatus> {
        model.fetchAllSubscriptionStatusesState
    }

    var body: some View {
        @Bindable var model = model

        mainContent(model: model)
            .toolbar { toolbarContent(bindableModel: $model) }
            .inspector(isPresented: $isInspectorPresented) {
                SubscriptionColumnInspectorView(
                    columnCustomization: $columnCustomization,
                    columnOrder: $columnOrder
                )
                .inspectorColumnWidth(min: 200, ideal: 280, max: 400)
            }
            .onChange(of: model.environment) { _, _ in
                Task {
                    await model.execute(action: .clearAllSubscriptionStatusesError)
                }
            }
            .onChange(of: model.transactionID) { (oldValue, newValue) in
                guard oldValue != newValue, !oldValue.isEmpty else { return }
                model.isStaledParameters = true
            }
            .onSubmit {
                Task {
                    model.isStaledParameters = false
                    await model.execute(action: .clearAllSubscriptionStatusesError)
                }
            }
            .textSelection(.enabled)
    }

    @ViewBuilder
    private func mainContent(model: IAPModel) -> some View {
        VStack {
            HStack {
                VStack(spacing: 12) {
                    Text("Get All Subscription Statuses")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "Get the statuses for all of a customer's auto-renewable subscriptions in your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)"
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                Image(systemName: "creditcard").font(.largeTitle).scenePadding()
            }
            .padding()
            Divider().padding(.horizontal)

            VStack {
                if let error = state.presentsError {
                    VStack {
                        Text("\(error.localizedDescription)")
                        Button("Retry") {
                            Task {
                                await model.execute(action: .clearAllSubscriptionStatusesError)
                            }
                        }
                    }
                } else if let subscriptionStatus = state.value {
                    SubscriptionStatusTableView(
                        model: subscriptionStatus,
                        columnCustomization: $columnCustomization,
                        columnOrder: columnOrder
                    )
                } else {
                    if model.transactionID.isEmpty {
                        Text("Enter TransactionID ⤴").font(.largeTitle)
                    } else {
                        ProgressView("Fetch App Store API...")
                            .task {
                                await model.execute(
                                    action: .fetchAllSubscriptionStatuses(
                                        transactionID: model.transactionID))
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
            TextField("TransactionID...", text: bindableModel.transactionID)
                .frame(idealWidth: 136)
        }
        toolbarSpacer()
        ToolbarItem {
            Button {
                Task {
                    bindableModel.wrappedValue.isStaledParameters = false
                    await bindableModel.wrappedValue.execute(
                        action: .clearAllSubscriptionStatusesError)
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .bold()
                    .foregroundStyle(
                        bindableModel.wrappedValue.isStaledParameters ? .orange : .primary)
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
    SubscriptionStatusView()
}
