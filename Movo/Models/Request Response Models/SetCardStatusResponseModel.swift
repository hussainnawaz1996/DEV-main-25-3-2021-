//
//  SetCardStatusResponseModel.swift
//  Movo
//
//  Created by Ahmad on 21/12/2020.
//

import Foundation

// MARK: - SetCardStatusResponseModel
struct SetCardStatusResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: CardStatusResponseModel?
}

// MARK: - DataClass
struct CardStatusResponseModel: Codable {
    let responseCode, responseDesc, cardNumber, cardReferenceID: String?
}
