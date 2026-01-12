//
//  ContentView.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/02/03.
//

import Dependencies
import IAPModel
import SwiftUI

public struct ContentView: View {

    enum Destination: Hashable {
        case notificationHistory
        case transactionHistory
        case transactionInfo
        case subscriptionStatus

        var title: String {
            switch self {
            case .notificationHistory:
                "Get Notification History"
            case .transactionHistory:
                "Get Transaction History"
            case .transactionInfo:
                "Get Transaction Info"
            case .subscriptionStatus:
                "Get All Subscription Statuses"
            }
        }
    }

    @Environment(IAPModel.self)
    private var model

    @State private var isInitialized = true
    @State private var selectedDestination: Destination = .notificationHistory

    public init() {}

    public var body: some View {
        if isInitialized {
            ProgressView("Setup...")
                .task {
                    await model.execute(action: .getRootCertificate)
                    await model.execute(action: .getCredential)
                    isInitialized = false
                }
        } else if model.isSetupLevel != 1.0 {
            ContentUnavailableView {
                Label("Setup API Credential!", systemImage: "sparkles")
            } description: {
                Text("Let's set up App Store Server API and use a convenient Viewer!")
            } actions: {
                SettingsLink().controlSize(.extraLarge).buttonStyle(.borderedProminent)
            }
        } else {
            NavigationSplitView {
                List(selection: $selectedDestination) {
                    Section("App Store Server Notifications history") {
                        Text(Destination.notificationHistory.title)
                            .tag(Destination.notificationHistory)
                            .lineLimit(2)
                    }
                    Section("In-app purchase history") {
                        Text(Destination.transactionHistory.title)
                            .tag(Destination.transactionHistory)
                            .lineLimit(2)
                        Text(Destination.transactionInfo.title)
                            .tag(Destination.transactionInfo)
                            .lineLimit(2)
                    }
                    Section("Subscription status") {
                        Text(Destination.subscriptionStatus.title)
                            .tag(Destination.subscriptionStatus)
                            .lineLimit(2)
                    }
                }
                .listStyle(.sidebar)
            } detail: {
                @Bindable var model = model

                switch selectedDestination {
                case .notificationHistory:
                    NotificationHistoryView()
                case .transactionHistory:
                    TransactionHistoryView()
                case .transactionInfo:
                    TransactionInfoView()
                case .subscriptionStatus:
                    SubscriptionStatusView()
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(IAPModel())
        .frame(minWidth: 1600, minHeight: 800)
}
