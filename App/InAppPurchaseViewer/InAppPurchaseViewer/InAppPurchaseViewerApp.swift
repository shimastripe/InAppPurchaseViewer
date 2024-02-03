//
//  InAppPurchaseViewerApp.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2024/02/03.
//

import IAPModel
import IAPView
import SwiftUI

@MainActor
@main
struct InAppPurchaseViewerApp: App {

    private let model = IAPModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(model)
        }
        Settings {
            SettingsView().environment(model)
        }
        .defaultPosition(.center)
    }
}
