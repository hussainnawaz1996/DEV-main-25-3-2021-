//
//  GetBillPaymentHistoryResponseModel.swift
//  Movo
//
//  Created by Ahmad on 16/12/2020.
//

import Foundation

// MARK: - GResponseModel
struct GetBillPaymentHistoryResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: BillPaymentResponseModel?
}

// MARK: - DataClass
struct BillPaymentResponseModel: Codable {
    let responseCode, responseDesc: String?
    let transactions: [BillPaymentModel]?
    let balance: Double?
    let balanceSpecified: Bool?
    let transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, transactions, balance, balanceSpecified
        case transID = "transId"
        case fee
    }
}

// MARK: - Transaction
struct BillPaymentModel: Codable {
    let billPaymentTransID: String?
    let amount: Double?
    let amountSpecified: Bool?
    let scheduledDate: String?
    let scheduledDateSpecified: Bool?
    let payeeSerialNo, payeeName, payeeAddress, payeeCity: String?
    let payeeState, payeeZip, payeeNickname, payeeAccountNumber: String?
    let status, transactionDescription: String?

    enum CodingKeys: String, CodingKey {
        case billPaymentTransID = "billPaymentTransId"
        case amount, amountSpecified, scheduledDate, scheduledDateSpecified, payeeSerialNo, payeeName, payeeAddress, payeeCity, payeeState, payeeZip, payeeNickname, payeeAccountNumber, status
        case transactionDescription = "description"
    }
}
