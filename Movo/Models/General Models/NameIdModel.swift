//
//  NameIdModel.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import Foundation

// MARK: - NameIdModel
struct NameIdModel: Codable {
    let id: Int?
    let name: String?
}



// MARK: - BoolResponseModel
struct BoolResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: Bool?
}


struct StringResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: String?
}

struct CustomAddPayeeModel {
    var selectedState : StateModel?
    var payeeName: String?
    var payeeSerioulNumber: String?
    var payeeAddress: String?
    var isSearchFlow: Bool
}
