//
//  SigninRequestModel.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import Foundation

// MARK: - SigninRequestModel
struct SigninRequestModel: Codable {
    let username, password, sessionID, lnSessionIDResponse: String?
    let deviceToken, deviceModel, os, version: String?
    let deviceType: Int?
    
    enum CodingKeys: String, CodingKey {
        case username, password
        case sessionID = "sessionId"
        case lnSessionIDResponse = "lnSessionIdResponse"
        case deviceToken, deviceModel, os, version, deviceType
    }
}


// MARK: - SigninResponseModel
struct SigninResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: LoginModel?
}

// MARK: - DataClass
struct LoginModel: Codable {
    let token, email, username, firstName: String?
    let middleName, lastName, profilePicture, profilePictureThumb, lastLogin, userID: String?
    let accountInfo: LoginAccountModel?

    enum CodingKeys: String, CodingKey {
        case token, email, username, firstName, middleName, lastName, profilePicture, profilePictureThumb, lastLogin
        case userID = "userId"
        case accountInfo
    }
}

// MARK: - AccountInfo
struct LoginAccountModel: Codable {
    let identificationTypeID: Int?
    let identificationValue, dateOfBirth: String?
    let genderID: Int?
    let email, cellCountryCode, cellPhoneNumber, addressLine1: String?
    let country, state, city, zipCode, profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case identificationTypeID = "identificationTypeId"
        case identificationValue, dateOfBirth
        case genderID = "genderId"
        case email, cellCountryCode, cellPhoneNumber, addressLine1, country, state, city, zipCode, profilePicture
    }
}

