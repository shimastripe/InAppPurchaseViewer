//
//  IAPEnvironment.swift
//
//
//  Created by shimastripe on 2024/02/06.
//

import Foundation

public struct IAPEnvironment: Sendable, Equatable, Codable {
    public let bundleID: String
    public let issuerID: String
    public let keyID: String
    public let appAppleID: Int
    public let encodedKey: String

    enum CodingKeys: String, CodingKey {
        case bundleID = "bundleId"
        case issuerID = "issuerId"
        case keyID = "keyId"
        case appAppleID = "appAppleId"
        case encodedKey
    }

    public init(
        bundleID: String, issuerID: String, keyID: String, appAppleID: Int, encodedKey: String
    ) {
        self.bundleID = bundleID
        self.issuerID = issuerID
        self.keyID = keyID
        self.appAppleID = appAppleID
        self.encodedKey = encodedKey
    }
}
