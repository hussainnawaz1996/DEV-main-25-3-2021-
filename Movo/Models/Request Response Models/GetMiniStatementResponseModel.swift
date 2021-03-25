//
//  GetMiniStatementResponseModel.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import Foundation

// MARK: - GetMiniStatementResponseModel
struct GetMiniStatementResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: MiniStatementResponseModel?
}

// MARK: - DataClass
struct MiniStatementResponseModel: Codable {
    let responseCode, responseDesc: String?
    let statement: StatementModel?
    let transID, arn, clerkID, customerID: String?
    let fee: Int?
    let feeSpecified: Bool?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, statement
        case transID = "transId"
        case arn
        case clerkID = "clerkId"
        case customerID = "customerId"
        case fee, feeSpecified
    }
}

// MARK: - Statement
struct StatementModel: Codable {
    let transactions: [TransactionModel]?
}

// MARK: - Transaction
struct TransactionModel: Codable {
    let cardProgramID, programAbbreviation, cardReferenceID, transID: String?
    let accountNumber, transTypeID, transDate: String?
    let transDateSpecified: Bool?
    let businessDate, acceptorNameAndLocation: String?
    let amount: Double?
    let amountSpecified: Bool?
    let currencyCode: String?
    let amountRequested: Double?
    let amountRequestedSpecified: Bool?
    let requestedCurrencyCode, transactionDescription, messageTypeIdentifier, arn: String?
    let cardAcceptorID, mcc, deviceID, deviceType: String?
    let merchantName, transactionExpiryDate: String?

    enum CodingKeys: String, CodingKey {
        case cardProgramID, programAbbreviation, cardReferenceID
        case transID = "transId"
        case accountNumber
        case transTypeID = "transTypeId"
        case transDate, transDateSpecified, businessDate, acceptorNameAndLocation, amount, amountSpecified, currencyCode, amountRequested, amountRequestedSpecified, requestedCurrencyCode
        case transactionDescription = "description"
        case messageTypeIdentifier, arn
        case cardAcceptorID = "cardAcceptorId"
        case mcc
        case deviceID = "deviceId"
        case deviceType, merchantName, transactionExpiryDate
    }
}
