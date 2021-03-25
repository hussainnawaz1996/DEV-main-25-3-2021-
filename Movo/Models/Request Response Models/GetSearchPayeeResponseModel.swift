//
//  GetSearchPayeeResponseModel.swift
//  Movo
//
//  Created by Ahmad on 14/12/2020.
//

import Foundation

// MARK: - SearchPayeeRequestModel
struct SearchPayeeRequestModel: Codable {
    let searchString: String
    let skip, take: Int
}


// MARK: - GetSearchPayeeResponseModel
struct GetSearchPayeeResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: SearchPayeeResponseModel?
}

// MARK: - DataClass
struct SearchPayeeResponseModel: Codable {
    let responseCode, responseDesc, transID: String?
    let noOfRecords: Int?
    let noOfRecordsSpecified: Bool?
    let payees: [PayeeModel]?

    enum CodingKeys: String, CodingKey {
        case responseCode, responseDesc
        case transID = "transId"
        case noOfRecords, noOfRecordsSpecified, payees
    }
}
