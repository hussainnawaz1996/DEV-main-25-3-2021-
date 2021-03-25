//
//  GetCardAuthResponseModel.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import Foundation

// MARK: - GetCardAuthResponseModel
struct GetCardAuthResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: CardAuthResponseModel?
}

// MARK: - DataClass
struct CardAuthResponseModel: Codable {
    let cvV2: String?
//    let balance: Int?
//    let expiryDate: String?
}
