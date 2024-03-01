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
public struct RootCertificateClient {

    public typealias Model = Data

    public enum RootCertificateClientError: LocalizedError {
        case notAcceptableStatus(Int)
    }

    public var fetch: () async throws -> Model

    public var get: () async throws -> Model?
    public var remove: () async throws -> Void
}

// MARK: Implementation

extension RootCertificateClient: TestDependencyKey {
    public static var testValue = Self()
    public static var previewValue: RootCertificateClient = .init(
        fetch: {
            unimplemented()
        },
        get: {
            Data()
        },
        remove: {
            unimplemented()
        })
}
