//
//  MakePaymentResponseModel.swift
//  Movo
//
//  Created by Ahmad on 15/12/2020.
//

import Foundation

// MARK: - MakePaymentResponseModel
struct MakePaymentRequestModel: Codable {
    let tansID, payeeSrNo: String?
    let payeeAccountNumber: String?
    let amount: String?
    let paymentDate, comments: String?

    enum CodingKeys: String, CodingKey {
        case tansID = "tansId"
        case payeeSrNo, payeeAccountNumber, amount, paymentDate, comments
    }
}


struct CustomMakePaymentModel {
    var payeeName: String?
    var selectedPayment: BillPaymentModel?
    var selectedCard: CardModel?
}


// MARK: - MakePaymentResponseModel
struct MakePaymentResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: MakePaymentModel?
}

// MARK: - DataClass
struct MakePaymentModel: Codable {
    let responseCode, responseDesc: String?
    let balance: Double?
    let balanceSpecified: Bool?
    let billPaymentTransID, billPaymentProcessingDays, businessDate, arn: String?
    let fee: String?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc, balance, balanceSpecified
        case billPaymentTransID = "billPaymentTransId"
        case billPaymentProcessingDays, businessDate, arn, fee
    }
}
