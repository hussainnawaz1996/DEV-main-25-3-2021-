//
//  UpdateCardNameModels.swift
//  Movo
//
//  Created by Ahmad on 09/01/2021.
//

import Foundation

// MARK: - UpdateCashCardNameRequestModel
struct UpdateCashCardNameRequestModel: Codable {
    let referenceID, nameOnCard: String?

    enum CodingKeys: String, CodingKey {
        case referenceID = "referenceId"
        case nameOnCard
    }
}
