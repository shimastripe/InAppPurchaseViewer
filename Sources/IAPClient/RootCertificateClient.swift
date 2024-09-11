//
//  RootCertificateClient.swift
//
//
//  Created by shimastripe on 2024/02/04.
//

import Dependencies
import Foundation
import HTTPTypes
import HTTPTypesFoundation
import IAPInterface
@preconcurrency import KeychainAccess

extension RootCertificateClient: DependencyKey {
    public static let liveValue: RootCertificateClient = {

        let keychain = Keychain()
        let modelKey = "appleRootCertificate"

        @Sendable
        func fetch() async throws -> Data {
            let request = HTTPRequest(
                method: .get, scheme: "https", authority: "www.apple.com",
                path: "/certificateauthority/AppleRootCA-G3.cer")
            let (responseBody, response) = try await URLSession.shared.data(for: request)
            guard response.status == .ok else {
                throw RootCertificateClientError.notAcceptableStatus(response.status.code)
            }
            return responseBody
        }

        @Sendable
        func get() throws -> Model? {
            try keychain.getData(modelKey)
        }

        @Sendable
        func set(model: Model) throws {
            try keychain.set(model, key: modelKey)
        }

        @Sendable
        func remove() throws {
            try keychain.remove(modelKey)
        }

        return .init(
            fetch: {
                let model = try await fetch()
                try set(model: model)
                return model
            },
            get: {
                try get()
            },
            remove: {
                try remove()
            })
    }()
}
