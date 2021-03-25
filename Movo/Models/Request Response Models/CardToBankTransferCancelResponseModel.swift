//
//  CardToBankTransferCancelResponseModel.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import Foundation


// MARK: - CashToBankTransferModel
struct CardToBankTransferCancelResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: C2BCancelTransferResponseModel?
}

// MARK: - DataClass
struct C2BCancelTransferResponseModel: Codable {
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
