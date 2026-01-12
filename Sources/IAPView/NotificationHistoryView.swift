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

    @SceneStorage("NotificationHistoryColumnCustomization")
    private var columnCustomization: TableColumnCustomization<NotificationHistoryItem>

    @SceneStorage("NotificationHistoryColumnOrder")
    private var columnOrder: NotificationColumnOrder = .init()

    @State private var isInspectorPresented = false

    private var state: LoadingViewState<NotificationHistoryModel> {
        model.fetchNotificationHistoryState
    }

    var body: some View {
        @Bindable var model = model

        mainContent(model: model)
            .toolbar { toolbarContent(bindableModel: $model) }
            .inspector(isPresented: $isInspectorPresented) {
                NotificationColumnInspectorView(
                    columnCustomization: $columnCustomization,
                    columnOrder: $columnOrder
                )
                .inspectorColumnWidth(min: 200, ideal: 280, max: 400)
            }
            .onChange(of: model.environment) { _, _ in
                Task {
                    await model.execute(action: .clearNotificationHistoryError)
                }
            }
            .onChange(of: model.notificationFilterOption) { oldValue, newValue in
                guard oldValue != newValue else { return }
                Task {
                    await model.execute(action: .clearNotificationHistoryError)
                }
            }
            .onChange(of: model.onlyFailuresFilter) { oldValue, newValue in
                guard oldValue != newValue else { return }
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

    @ViewBuilder
    private func mainContent(model: IAPModel) -> some View {
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
                    NotificationHistoryTableView(
                        model: transaction,
                        columnCustomization: $columnCustomization,
                        columnOrder: columnOrder
                    )

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
    }

    @ToolbarContentBuilder
    private func toolbarContent(bindableModel: Bindable<IAPModel>) -> some ToolbarContent {
        toolbarLeadingContent(bindableModel: bindableModel)
        toolbarFilterContent(bindableModel: bindableModel)
        toolbarTrailingContent(bindableModel: bindableModel)
    }

    @ToolbarContentBuilder
    private func toolbarLeadingContent(bindableModel: Bindable<IAPModel>) -> some ToolbarContent {
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
            TextField("TransactionID...", text: bindableModel.notificationHistoryTransactionID)
                .frame(idealWidth: 136)
        }
        toolbarSpacer()
        ToolbarItem {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                TextField("", value: bindableModel.notificationStartDate, format: .dateTime)
                Text("〜")
                TextField("", value: bindableModel.notificationEndDate, format: .dateTime)
            }
        }
        toolbarSpacer()
    }

    @ToolbarContentBuilder
    private func toolbarFilterContent(bindableModel: Bindable<IAPModel>) -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button {
                    bindableModel.wrappedValue.notificationFilterOption = nil
                } label: {
                    if bindableModel.wrappedValue.notificationFilterOption == nil {
                        Label("All Types", systemImage: "checkmark")
                    } else {
                        Text("All Types")
                    }
                }
                Divider()
                ForEach(NotificationFilterOption.allOptions) { option in
                    Button {
                        bindableModel.wrappedValue.notificationFilterOption = option
                    } label: {
                        if bindableModel.wrappedValue.notificationFilterOption == option {
                            Label(option.displayName, systemImage: "checkmark")
                        } else {
                            Text(option.displayName)
                        }
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .symbolVariant(
                        bindableModel.wrappedValue.notificationFilterOption == nil ? .none : .fill)
            }
            .disabled(!bindableModel.wrappedValue.notificationHistoryTransactionID.isEmpty)
        }
        toolbarSpacer()
        ToolbarItem {
            Button {
                if bindableModel.wrappedValue.onlyFailuresFilter == true {
                    bindableModel.wrappedValue.onlyFailuresFilter = nil
                } else {
                    bindableModel.wrappedValue.onlyFailuresFilter = true
                }
            } label: {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(
                        bindableModel.wrappedValue.onlyFailuresFilter == true ? .fill : .none)
            }
            .help(
                "Request only the notifications that haven't reached your server successfully. The response also includes notifications that the App Store server is currently retrying to send to your server."
            )
        }
        toolbarSpacer()
    }

    @ToolbarContentBuilder
    private func toolbarTrailingContent(bindableModel: Bindable<IAPModel>) -> some ToolbarContent {
        ToolbarItem {
            Button {
                bindableModel.wrappedValue.resetNotificationDates()
            } label: {
                Image(systemName: "eraser").bold()
            }
        }
        toolbarSpacer()
        ToolbarItem {
            Button {
                Task {
                    bindableModel.wrappedValue.isNotificationHistoryStaledParameters = false
                    await bindableModel.wrappedValue.execute(action: .clearNotificationHistoryError)
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .bold()
                    .foregroundStyle(
                        bindableModel.wrappedValue.isNotificationHistoryStaledParameters
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
