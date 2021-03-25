//
//  CreateBankAccountRequestModel.swift
//  Movo
//
//  Created by Ahmad on 06/12/2020.
//

import Foundation

// MARK: - CreateBankAccountRequestModel
struct CreateBankAccountRequestModel: Codable {
    let bankSerialNumberIfEdit: String?
    let accountType: Int?
    let legalName, bankName, routingNumber: String?
    let isCheckingAccount: Bool?
    let bankAccountNumber, nickName, comments: String?
}



// MARK: - CreateBankAccountResponseModel
struct CreateBankAccountResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: BankAccountResponseModel?
}

// MARK: - DataClass
struct BankAccountResponseModel: Codable {
    let responseCode, responseDesc, accountSrNo, status: String?
    let b2CMinTransferDays, b2CMaxTransferDays, c2BMinTransferDays, c2BMaxTransferDays: String?
    let balance, transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, accountSrNo, status, b2CMinTransferDays, b2CMaxTransferDays, c2BMinTransferDays, c2BMaxTransferDays, balance
        case transID = "transId"
        case fee
    }
}


