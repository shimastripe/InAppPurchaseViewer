//
//  NotificationHistoryView.swift
//
//
//  Created by shimastripe on 2024/02/08.
//

import IAPInterface
import IAPModel
import SwiftUI

struct NotificationHistoryView: View {

    @Environment(IAPModel.self)
    private var model

    private var state: LoadingViewState<NotificationHistoryModel> {
        model.fetchNotificationHistoryState
    }

    var body: some View {
        @Bindable var model = model

        VStack {
            HStack {
                VStack(spacing: 12) {
                    Text("Get Notification History")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "Get a list of notifications that the App Store server attempted to send to your server. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_notification_history)"
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                Image(systemName: "info.bubble").font(.largeTitle).scenePadding()
            }
            .padding()
            Divider().padding(.horizontal)

            VStack {
                if let error = state.presentsError {
                    VStack {
                        Text("\(error.localizedDescription)")
                        Button("Retry") {
                            Task {
                                await model.execute(action: .clearNotificationHistoryError)
                            }
                        }
                    }
                } else if let transaction = state.value {
                    NotificationHistoryTableView(model: transaction)

                    if let hasMore = transaction.hasMore, hasMore,
                        transaction.paginationToken != nil
                    {
                        VStack {
                            ZStack {
                                ProgressView("Fetch App Store API...").opacity(
                                    !state.isAppendLoading ? 0 : 1)
                                HStack {
                                    Button {
                                        Task {
                                            await model.execute(
                                                action: .appendFetchNotificationHistory(
                                                    startDate: model.notificationStartDate,
                                                    endDate: model.notificationEndDate,
                                                    transactionID: model
                                                        .notificationHistoryTransactionID))
                                        }
                                    } label: {
                                        Label("20", systemImage: "plus.app")
                                            .font(.title)
                                            .padding(8)
                                    }
                                    Button {
                                        Task {
                                            await model.execute(
                                                action: .bulkAppendFetchNotificationHistory(
                                                    startDate: model.notificationStartDate,
                                                    endDate: model.notificationEndDate,
                                                    transactionID: model
                                                        .notificationHistoryTransactionID))
                                        }
                                    } label: {
                                        Label("200", systemImage: "plus.rectangle.on.rectangle")
                                            .font(.title)
                                            .padding(8)
                                    }
                                    .help("Retrieves 200 items for a given period of time")
                                }
                                .opacity(state.isAppendLoading ? 0 : 1)
                            }
                        }
                        .padding()
                    }
                } else {
                    ProgressView("Fetch App Store API...")
                        .task {
                            await model.execute(
                                action: .fetchNotificationHistory(
                                    startDate: model.notificationStartDate,
                                    endDate: model.notificationEndDate,
                                    transactionID: model.notificationHistoryTransactionID
                                ))
                        }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem {
                Picker("", selection: $model.environment) {
                    ForEach(ServerEnvironment.allCases) {
                        Label("\($0.description)", systemImage: $0.symbol).tag($0).labelStyle(
                            .titleAndIcon)
                    }
                }
            }
            ToolbarItem {
                // Hack to align height with other Items
                ZStack(alignment: .centerFirstTextBaseline) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("TransactionID").layoutPriority(1)
                        TextField("2000000123456789", text: $model.notificationHistoryTransactionID)
                            .frame(idealWidth: 136)
                    }
                    // shadow item
                    DatePicker(
                        "", selection: .constant(.distantPast),
                        displayedComponents: [.date, .hourAndMinute]
                    ).opacity(0)
                }
            }
            ToolbarItem {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("StartDate")
                    DatePicker(
                        "", selection: $model.notificationStartDate,
                        displayedComponents: [.date, .hourAndMinute])
                }
            }
            ToolbarItem {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("EndDate")
                    DatePicker(
                        "", selection: $model.notificationEndDate,
                        displayedComponents: [.date, .hourAndMinute])
                }
            }
            ToolbarItem {
                Button {
                    model.resetNotificationDates()
                } label: {
                    Image(systemName: "eraser").bold()
                }
            }
            ToolbarItem {
                Button {
                    Task {
                        model.isNotificationHistoryStaledParameters = false
                        await model.execute(action: .clearNotificationHistoryError)
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .bold()
                        .foregroundStyle(
                            model.isNotificationHistoryStaledParameters
                                ? .orange : .gray.opacity(0.7))
                }
                .help("Retry")
            }
        }
        .onChange(of: model.environment) { _, _ in
            Task {
                await model.execute(action: .clearNotificationHistoryError)
            }
        }
        .onChange(of: [
            model.notificationHistoryTransactionID, model.notificationStartDate.formatted(),
            model.notificationEndDate.formatted(),
        ]) { (oldValue, newValue) in
            guard oldValue != newValue else { return }
            model.isNotificationHistoryStaledParameters = true
        }
        .onSubmit {
            Task {
                model.isNotificationHistoryStaledParameters = false
                await model.execute(action: .clearNotificationHistoryError)
            }
        }
        .textSelection(.enabled)
    }
}
