//
//  AddCashCardRequestModel.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import Foundation

// MARK: - AddCashCardRequestModel
struct AddCashCardRequestModel: Codable {
    let fromReferenceID: String?
    let amount: String?
    let nameOnCard: String?

    enum CodingKeys: String, CodingKey {
        case fromReferenceID = "fromReferenceId"
        case amount, nameOnCard
    }
}




// MARK: - AddCashCardResopnseModel
struct AddCashCardResopnseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: CashCardResponseModel?
}

// MARK: - DataClass
struct CashCardResponseModel: Codable {
    let responseDesc: String?

    enum CodingKeys: String, CodingKey {
        case responseDesc
    }
}
