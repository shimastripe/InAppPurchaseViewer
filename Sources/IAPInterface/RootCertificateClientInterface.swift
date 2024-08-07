//
//  RootCertificateClientInterface.swift
//
//
//  Created by shimastripe on 2024/02/04.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct RootCertificateClient: Sendable {

    public typealias Model = Data

    public enum RootCertificateClientError: LocalizedError {
        case notAcceptableStatus(Int)
    }

    public var fetch: @Sendable () async throws -> Model

    public var get: @Sendable () async throws -> Model?
    public var remove: @Sendable () async throws -> Void
}

// MARK: Implementation

extension RootCertificateClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue: RootCertificateClient = .init(
        fetch: {
            unimplemented(placeholder: Data())
        },
        get: {
            Data()
        },
        remove: {
            unimplemented(placeholder: ())
        })
}
