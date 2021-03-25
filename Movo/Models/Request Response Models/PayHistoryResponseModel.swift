//
//  PayHistoryResponseModel.swift
//  Movo
//
//  Created by Ahmad on 24/11/2020.
//

import Foundation

// MARK: - PayHistoryResponseModel
struct PayHistoryResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: [PayHistoryModel]?
}

// MARK: - Datum
struct PayHistoryModel: Codable {
    let createdOn: String?
    let label: String?
    let amount: Double?
    let payTo, status: String?
}
