//
//  GetCountriesResponseModel.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import Foundation


// MARK: - GetCountriesResponseModel
struct GetCountriesResponseModel: Codable {
    let isError: Bool
    let messages: String
    let data: [NameIdModel]?
}


struct GetStatesResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: [StateModel]?
}

struct StateModel: Codable {
    let id: Int?
    let name: String?
    let iso2: String?
}

