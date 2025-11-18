//
//  Toolbar+.swift
//  InAppPurchaseViewer
//
//  Created by shimastripe on 2025/11/19.
//

import SwiftUI

extension View {
    @ToolbarContentBuilder
    func toolbarSpacer() -> some ToolbarContent {
        if #available(macOS 26.0, *) {
            ToolbarSpacer()
        } else {
            ToolbarItem {}
        }
    }
}
