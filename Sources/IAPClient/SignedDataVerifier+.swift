//
//  SignedDataVerifier+.swift
//
//
//  Created by shimastripe on 2024/02/18.
//

import AppStoreServerLibrary
import Foundation

extension VerificationError: Error {}

extension SignedDataVerifier {

    func verifyAndDecodeNotification(_ signedPayload: String)
        async throws -> ResponseBodyV2DecodedPayload
    {
        let result = await verifyAndDecodeNotification(
            signedPayload: signedPayload)
        switch result {
        case .valid(let payload):
            return payload
        case .invalid(let error):
            throw error
        }
    }

    func verifyAndDecodeTransaction(_ signedTransaction: String)
        async throws -> JWSTransactionDecodedPayload
    {
        let result = await verifyAndDecodeTransaction(signedTransaction: signedTransaction)
        switch result {
        case .valid(let transaction):
            return transaction
        case .invalid(let error):
            throw error
        }
    }

    func verifyAndDecodeRenewalInfo(_ signedRenewalInfo: String)
        async throws -> JWSRenewalInfoDecodedPayload
    {
        let result = await verifyAndDecodeRenewalInfo(signedRenewalInfo: signedRenewalInfo)
        switch result {
        case .valid(let renewalInfo):
            return renewalInfo
        case .invalid(let error):
            throw error
        }
    }
}
