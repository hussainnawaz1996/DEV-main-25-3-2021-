//
//  GetCardHolderProfileResponseModel.swift
//  Movo
//
//  Created by Ahmad on 27/12/2020.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getCardHolderProfileResponseModel = try? newJSONDecoder().decode(GetCardHolderProfileResponseModel.self, from: jsonData)

import Foundation

// MARK: - GetCardHolderProfileResponseModel
struct GetProfileHolderResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: ProfileHolderResponseModel?
}

// MARK: - DataClass
struct ProfileHolderResponseModel: Codable {
    let responseCode, responseDesc, cardNumber: String?
    let status: StatusModel?
    let pinOffset, balance, transID, arn: String?
    let clerkID, customerID, fee, referenceID: String?
    let pseudoDDANumber, abaRoutingNumber, lastDepositDate, lastDepositAmount: String?
    let firstName, middleName, lastName, suffix: String?
    let address1, address2, address3, address4: String?
    let address5, dob, city, stateCode: String?
    let postalCode, country, phone, residentialPhone: String?
    let billingAddress1, billingAddress2, billingAddress3, billingAddress4: String?
    let billingAddress5, billingCity, billingStateCode, billingPostalCode: String?
    let billingCountry, expDate, cardProgramID, cardType: String?
    let fulfillmentHouse, statusCode, cellNumber, email: String?
    let genderSpecified: Bool?
    let ssn, drivingLicense, drivingLicenseState, foreignID: String?
    let foreignIDType, foreignCountryCode, fundsExpiryDate: String?
    let transitionFlag: Int?
    let transitionFlagSpecified: Bool?
    let citizenCountry, occupation, memberNumber: String?
    let cipCleared: Int?
    let cipClearedSpecified: Bool?
    let nameofEmployer, employmentStatus, sourceCardNo, sourceCardReferenceNo: String?
    let stakeholderID: String?
    let deliveryMethodSpecified: Bool?
    let achProcessingDays: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, cardNumber, status, pinOffset, balance
        case transID = "transId"
        case arn, clerkID
        case customerID = "customerId"
        case fee, referenceID, pseudoDDANumber, abaRoutingNumber, lastDepositDate, lastDepositAmount, firstName, middleName, lastName, suffix, address1, address2, address3, address4, address5, dob, city, stateCode, postalCode, country, phone, residentialPhone, billingAddress1, billingAddress2, billingAddress3, billingAddress4, billingAddress5, billingCity, billingStateCode, billingPostalCode, billingCountry, expDate, cardProgramID, cardType, fulfillmentHouse, statusCode, cellNumber, email, genderSpecified, ssn, drivingLicense, drivingLicenseState, foreignID, foreignIDType, foreignCountryCode, fundsExpiryDate, transitionFlag, transitionFlagSpecified, citizenCountry, occupation, memberNumber, cipCleared, cipClearedSpecified, nameofEmployer, employmentStatus, sourceCardNo, sourceCardReferenceNo
        case stakeholderID = "stakeholderId"
        case deliveryMethodSpecified, achProcessingDays
    }
}

// MARK: - Status
struct StatusModel: Codable {
    let code, statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case code
        case statusDescription = "description"
    }
}
