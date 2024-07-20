//
//  CredentialClient.swift
//
//
//  Created by shimastripe on 2024/02/06.
//

import Dependencies
import Foundation
import IAPInterface
import KeychainAccess

extension CredentialClient: DependencyKey {

    public static let liveValue: IAPInterface.CredentialClient = {
        let keychain = Keychain()
        let modelKey = "appleServerAPICredential"

        @Sendable
        func get() throws -> Model? {
            guard let data = try keychain.getData(modelKey) else { return nil }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Model.self, from: data)
        }

        @Sendable
        func set(
            bundleID: String, issuerID: String, keyID: String, appAppleID: Int,
            privateKeyFileURL: URL
        ) throws {
            guard privateKeyFileURL.startAccessingSecurityScopedResource() else {
                throw CredentialClientError.missingEncryptedFile
            }
            defer {
                privateKeyFileURL.stopAccessingSecurityScopedResource()
            }

            guard
                let encodedKey = String(
                    data: try .init(contentsOf: privateKeyFileURL), encoding: .utf8)
            else {
                throw CredentialClientError.encodingError
            }
            let model = Model(
                bundleID: bundleID, issuerID: issuerID, keyID: keyID, appAppleID: appAppleID,
                encodedKey: encodedKey)
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(model)
            try keychain.set(data, key: modelKey)
        }

        @Sendable
        func remove() throws {
            try keychain.remove(modelKey)
        }

        return .init(
            get: {
                try get()
            },
            set: { bundleID, issuerID, keyID, appAppleID, privateKeyFileURL in
                try set(
                    bundleID: bundleID, issuerID: issuerID, keyID: keyID, appAppleID: appAppleID,
                    privateKeyFileURL: privateKeyFileURL)
            },
            remove: {
                try remove()
            })
    }()
}
