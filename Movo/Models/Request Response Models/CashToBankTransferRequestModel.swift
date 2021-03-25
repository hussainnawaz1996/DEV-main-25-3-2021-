//
//  CashToBankTransferRequestModel.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import Foundation

// MARK: - CashToBankTransferRequestModel
struct CashToBankTransferRequestModel: Codable {
    let transferID, accountSrNo: String?
    let amount: String?
    let transferComments: String?
    let transferFrequency: Int?
    let transferDate: String?

    enum CodingKeys: String, CodingKey {
        case transferID = "transferId"
        case accountSrNo, amount, transferComments, transferFrequency, transferDate
    }
}


// MARK: - CashToBankTransferRequestModel
struct CashToBankTransferResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: C2BResponSeModel?
}

// MARK: - DataClass
struct C2BResponSeModel: Codable {
    let responseCode, responseDesc, customerID, referenceID: String?
    let transferID, recurrenceID, alertID, balance: String?
    let transID, fee, cardProgramName: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc
        case customerID = "customerId"
        case referenceID
        case transferID = "transferId"
        case recurrenceID = "recurrenceId"
        case alertID = "alertId"
        case balance
        case transID = "transId"
        case fee, cardProgramName
    }
}
