//
//  CardToBankTransferListResponseModel.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import Foundation

// MARK: - CashToBankTransferLisRequestModel
struct CashToBankTransferListResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: C2BTransferListResposnseModel?
}

// MARK: - DataClass
struct C2BTransferListResposnseModel: Codable {
    let responseCode, responseDesc, customerID, referenceID: String?
    let singleTransfers: [TransferModel]?
    let balance, transID, fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc
        case customerID = "customerId"
        case referenceID, singleTransfers, balance
        case transID = "transId"
        case fee
    }
}

// MARK: - SingleTransfer
struct TransferModel: Codable {
    let transferID, amount, transferDate, status: String?
    let transferFrom, transferTo, transferComments: String?
    let achType: Int?
    let achTypeSpecified: Bool?
    let impactCard: Int?
    let originationDate, debitTraceAuditNo, creditTraceAuditNo, returnCode: String?
    let returnDate: String?

    enum CodingKeys: String, CodingKey {
        case transferID = "transferId"
        case amount, transferDate, status, transferFrom, transferTo, transferComments, achType, achTypeSpecified, impactCard, originationDate, debitTraceAuditNo, creditTraceAuditNo, returnCode, returnDate
    }
}
