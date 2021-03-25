//
//  GetFeeResponseModel.swift
//  Movo
//
//  Created by Ahmad on 03/01/2021.
//

import Foundation


// MARK: - GetFeeResponseModel
struct GetFeeResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: FeeResponseModel?
}

// MARK: - DataClass
struct FeeResponseModel: Codable {
    let balance, fee, minLoadAmount, requestedServiceFee: String?

    enum CodingKeys: String, CodingKey {
        case balance, fee, minLoadAmount, requestedServiceFee
    }
}
