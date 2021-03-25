//
//  AddPayeeModels.swift
//  Movo
//
//  Created by Ahmad on 10/12/2020.
//

import Foundation


// MARK: - AddPayeeRequestModel
struct AddPayeeRequestModel: Codable {
    let srNo, payeeName, address, city: String?
    let stateID: Int?
    let stateIso2, zip, nickName, depositAccountNumber: String?

    enum CodingKeys: String, CodingKey {
        case srNo, payeeName, address, city
        case stateID = "stateId"
        case stateIso2, zip, nickName, depositAccountNumber
    }
}


// MARK: - AddPayeeResponseModel
struct AddPayeeResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: PayeeResponseModel?
}

// MARK: - DataClass
struct PayeeResponseModel: Codable {
    let responseCode, responseDesc: String?
    let balance: Double?
    let balanceSpecified: Bool?
    let transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, balance, balanceSpecified
        case transID = "transId"
        case fee
    }
}
