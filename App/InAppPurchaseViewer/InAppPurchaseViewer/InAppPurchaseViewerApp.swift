//
//  InAppPurchaseViewerApp.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/02/03.
//

import IAPModel
import IAPView
import Sparkle
import SwiftUI

@MainActor
@main
struct InAppPurchaseViewerApp: App {

    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)

    private let model = IAPModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(model)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates...",
                       action: updaterController.updater.checkForUpdates)
            }
        }
        Settings {
            SettingsView().environment(model)
        }
        .defaultPosition(.center)
    }
}
