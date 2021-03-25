//
//  RemoveBankAccountModels.swift
//  Movo
//
//  Created by Ahmad on 07/12/2020.
//

import Foundation

struct RemoveBankAccountRequestModel: Codable {
    let accountSerialNo : String?
}

// MARK: - RemoveBankAccountResponseModel
struct RemoveBankAccountResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: RemoveBankAccountModel?
}

// MARK: - DataClass
struct RemoveBankAccountModel: Codable {
    let responseCode, responseDesc, accountSrNo, status: String?
    let b2CMinTransferDays, b2CMaxTransferDays, c2BMinTransferDays, c2BMaxTransferDays: String?
    let balance, transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, accountSrNo, status, b2CMinTransferDays, b2CMaxTransferDays, c2BMinTransferDays, c2BMaxTransferDays, balance
        case transID = "transId"
        case fee
    }
}
