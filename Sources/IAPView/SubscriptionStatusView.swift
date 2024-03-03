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

    private var state: LoadingViewState<SubscriptionStatus> {
        model.fetchAllSubscriptionStatusesState
    }

    var body: some View {
        @Bindable var model = model

        VStack {
            HStack {
                VStack(spacing: 12) {
                    Text("Get All Subscription Statuses")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "Get the statuses for all of a customer’s auto-renewable subscriptions in your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)"
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
                    SubscriptionStatusTableView(model: subscriptionStatus)
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
                Button {
                    Task {
                        model.isStaledParameters = false
                        await model.execute(action: .clearAllSubscriptionStatusesError)
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .bold()
                        .foregroundStyle(model.isStaledParameters ? .orange : .gray.opacity(0.7))
                }
                .help("Retry")
            }
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
}

#Preview {
    SubscriptionStatusView()
}
