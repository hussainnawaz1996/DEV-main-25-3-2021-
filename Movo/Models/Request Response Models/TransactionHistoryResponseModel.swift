//
//  TransactionHistoryResponseModel.swift
//  Movo
//
//  Created by Ahmad on 25/11/2020.
//

import Foundation

// MARK: - TransactionHistoryResponseModel
struct TransactionHistoryResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: TransactionHistoryModel?
}

// MARK: - DataClass
struct TransactionHistoryModel: Codable {
    let responseCode, responseDesc: String?
    let statement: Statement?
    let balance, transID, arn, clerkID: String?
    let customerID, fee, businessDate, cardProgramName: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, statement, balance
        case transID = "transId"
        case arn, clerkID
        case customerID = "customerId"
        case fee, businessDate, cardProgramName
    }
}

// MARK: - Statement
struct Statement: Codable {
    let currentBalance: String?
    let transactions: [Transaction]?
}

// MARK: - Transaction
struct Transaction: Codable {
    let transID, traceAuditNo, originalTraceAuditNo: String?
    let additional: JSONNull?
    let accountNumber, transTypeID, transDate: String?
    let transDateSpecified: Bool?
    let businessDate, acceptorNameAndLocation, availableBalance, remainingBalance: String?
    let amount, transactionDescription, messageTypeIdentifier: String?
    let billedSpecified: Bool?
    let arn, cardAcceptorID, mcc, deviceID: String?
    let deviceType, merchantName, panSequenceNo, transactionExpiryDate: String?
    let disputeTypeSpecified, disputeStatusSpecified, disputeAmountSpecified, disputeDateSpecified: Bool?
    let isPaymentTrans, walletTokenNo, walletTokenRequesterID, walletTokenType: String?
    let walletTokenExpiry, authorizationCode, additionalAmount: String?

    enum CodingKeys: String, CodingKey {
        case transID = "transId"
        case traceAuditNo, originalTraceAuditNo, additional, accountNumber
        case transTypeID = "transTypeId"
        case transDate, transDateSpecified, businessDate, acceptorNameAndLocation, availableBalance, remainingBalance, amount
        case transactionDescription = "description"
        case messageTypeIdentifier, billedSpecified, arn
        case cardAcceptorID = "cardAcceptorId"
        case mcc
        case deviceID = "deviceId"
        case deviceType, merchantName, panSequenceNo, transactionExpiryDate, disputeTypeSpecified, disputeStatusSpecified, disputeAmountSpecified, disputeDateSpecified, isPaymentTrans, walletTokenNo
        case walletTokenRequesterID = "walletTokenRequesterId"
        case walletTokenType, walletTokenExpiry, authorizationCode, additionalAmount
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
