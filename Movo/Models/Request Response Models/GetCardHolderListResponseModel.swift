//
//  GetCardHolderListResponseModel.swift
//  Movo
//
//  Created by Ahmad on 10/12/2020.
//

import Foundation

// MARK: - GetCardHolderListResponseModel
struct GetCardHolderListResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: CardHolderResponseModel?
}

// MARK: - DataClass
struct CardHolderResponseModel: Codable {
    let responseCode, responseDesc: String?
    let balance: Double?
    let balanceSpecified: Bool?
    let totalRecords, totalLength, transID, fee: String?
    let payees: [PayeeModel]?
    let audioRecords: [AudioRecordModel]?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, balance, balanceSpecified, totalRecords, totalLength
        case transID = "transId"
        case fee, payees, audioRecords
    }
}

// MARK: - AudioRecord
struct AudioRecordModel: Codable {
    let audioFile, recordNumber, bankAccountNumber, bpConsumerAccountNo: String?
    let achAcctNick, isTextNick, pwProgramID: String?

    enum CodingKeys: String, CodingKey {
        case audioFile, recordNumber, bankAccountNumber, bpConsumerAccountNo, achAcctNick, isTextNick
        case pwProgramID = "pwProgramId"
    }
}

// MARK: - Payee
struct PayeeModel: Codable {
    let payeeSerialNo, addressSerialNo, payeeID, payeeName: String?
    let payeeAddress, payeeAddress2, payeeAddress3, payeeAddress4: String?
    let payeeCity, payeeState, payeeCountryCode, payeeCID: String?
    let payeeZip, payeeNickname, payeeAccountNumber, bankCode: String?
    let switchID: String?

    enum CodingKeys: String, CodingKey {
        case payeeSerialNo, addressSerialNo
        case payeeID = "payeeId"
        case payeeName, payeeAddress, payeeAddress2, payeeAddress3, payeeAddress4, payeeCity, payeeState, payeeCountryCode
        case payeeCID = "payeeCId"
        case payeeZip, payeeNickname, payeeAccountNumber, bankCode
        case switchID = "switchId"
    }
}
