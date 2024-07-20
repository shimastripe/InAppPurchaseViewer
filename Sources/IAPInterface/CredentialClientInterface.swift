//
//  CredentialClientInterface.swift
//
//
//  Created by shimastripe on 2024/02/04.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct CredentialClient: Sendable {

    public typealias Model = IAPEnvironment

    public enum CredentialClientError: LocalizedError {
        case encodingError
        case missingEncryptedFile
        case notAcceptableStatus(Int)
    }

    public var get: @Sendable () async throws -> Model?
    public var set:
        @Sendable
        (
            _ bundleID: String, _ issuerID: String, _ keyID: String, _ appAppleID: Int,
            _ privateKeyFileURL: URL
        )
            async throws -> Void
    public var remove: @Sendable () async throws -> Void
}

// MARK: Implementation

extension CredentialClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue: CredentialClient = .init {
        .init(bundleID: "", issuerID: "", keyID: "", appAppleID: 0, encodedKey: "")
    } set: { _, _, _, _, _ in
        unimplemented()
    } remove: {
        unimplemented()
    }
}
