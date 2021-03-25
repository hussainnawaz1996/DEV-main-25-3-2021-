//
//  UpdateProfileResponseModel.swift
//  Movo
//
//  Created by Ahmad on 27/12/2020.
//

import Foundation

// MARK: - UpdateProfileResponseModel
struct UpdateProfileRequestModel: Codable {
    let email, cellCountryCode, cellPhoneNumber: String?
    let addressInformation, shippingInformation: InformationModel?
}

// MARK: - Information
struct InformationModel: Codable {
    let addressLine1: String?
    let countryID, stateID: Int?
    let stateIso2, city, zipCode: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1
        case countryID = "countryId"
        case stateID = "stateId"
        case stateIso2, city, zipCode
    }
}





// MARK: - UpdateProfileResponseModel
struct UpdateProfileResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: UpdateProfileModel?
}

// MARK: - DataClass
struct UpdateProfileModel: Codable {
    let responseCode, responseDesc: String?
}
