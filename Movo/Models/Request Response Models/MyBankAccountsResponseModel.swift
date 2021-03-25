//
//  MyBankAccountsResponseModel.swift
//  Movo
//
//  Created by Ahmad on 07/12/2020.
//

import Foundation

// MARK: - MyBankAccountsResponseModel
struct MyBankAccountsResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: MyBankAccountModel?
}

// MARK: - DataClass
struct MyBankAccountModel: Codable {
    let responseCode, responseDesc, customerID: String?
    let accounts: [AccountModel]?
    let noOfRecords: Int?
    let noOfRecordsSpecified: Bool?
    let balance, transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc
        case customerID = "customerId"
        case accounts, noOfRecords, noOfRecordsSpecified, balance
        case transID = "transId"
        case fee
    }
}

// MARK: - Account
struct AccountModel: Codable {
    let accountSrNo, accountNumber, accountTitle: String?
    let accountType: Int?
    let accountTypeSpecified: Bool?
    let accountNickname: String?
    let achType: Int?
    let achTypeSpecified: Bool?
    let bankName, routingNumber, comments, status: String?
    let failedRegistrationTries, createdAt, registrationExpiresAt: String?
    let editAllowed: Int?
    let editAllowedSpecified: Bool?
    let deleteAllowed: Int?
    let deleteAllowedSpecified: Bool?
    let verificationAllowed: Int?
    let verificationAllowedSpecified: Bool?
    let trialACHDate, trialACHReturnDate, trialACHReturnCode, trialACHNOCCode: String?
    let trialACHNOCData, accountVerifiedOn: String?
}
