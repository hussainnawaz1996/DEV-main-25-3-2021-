//
//  GetSigninTokenModels.swift
//  Movo
//
//  Created by Ahmad on 31/01/2021.
//

import Foundation

// MARK: - GetSigninTokenRequestModel
struct GetSigninTokenRequestModel: Codable {
    let referenceID, entityID: String?

    enum CodingKeys: String, CodingKey {
        case referenceID = "referenceId"
        case entityID = "entityId"
    }
}

// MARK: - GetSigninTokenResponseModel
struct GetSigninTokenResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: SignintokenModel?
}

// MARK: - DataClass
struct SignintokenModel: Codable {
    let responseCode, responseDesc, arn, signOnToken: String?
}
