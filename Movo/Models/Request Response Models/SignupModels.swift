//
//  SignupModels.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import Foundation

// MARK: - SignupRequestModel
struct SignupRequestModel: Codable {
    let firstName, lastName: String
    let identificationTypeID: Int
    let identificationValue, dateOfBirth: String
    let genderID: Int?
    let email, cellCountryCode, cellPhoneNumber, addressLine1: String
    let countryID, stateID: Int?
    let city, zipCode, lnSessionID: String
    let lnSessionIDResponse: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case identificationTypeID = "identificationTypeId"
        case identificationValue, dateOfBirth
        case genderID = "genderId"
        case email, cellCountryCode, cellPhoneNumber, addressLine1
        case countryID = "countryId"
        case stateID = "stateId"
        case city, zipCode
        case lnSessionID = "lnSessionId"
        case lnSessionIDResponse = "lnSessionIdResponse"
    }
}


// MARK: - SignupResponseModel
struct SignupResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: SignupModel?
}

// MARK: - DataClass
struct SignupModel: Codable {
    let reviewStatus: String?
}
