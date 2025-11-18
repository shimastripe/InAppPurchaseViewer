//
//  ServerEnvironment.swift
//
//
//  Created by shimastripe on 2024/02/18.
//

import Foundation

import struct SwiftUI.Color

public enum ServerEnvironment: Identifiable, Hashable, CustomStringConvertible, CaseIterable,
    Sendable
{
    case sandbox
    case production

    public var id: String {
        description
    }

    public var description: String {
        switch self {
        case .sandbox:
            "Sandbox"
        case .production:
            "Production"
        }
    }

    public var symbol: String {
        switch self {
        case .sandbox:
            "hare"
        case .production:
            "tortoise"
        }
    }

    public var symbolColor: Color {
        switch self {
        case .sandbox:
            Color.red
        case .production:
            Color.green
        }
    }
}
