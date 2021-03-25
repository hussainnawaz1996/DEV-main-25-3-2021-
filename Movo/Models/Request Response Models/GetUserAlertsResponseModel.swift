//
//  GetUserAlertsResponseModel.swift
//  Movo
//
//  Created by Ahmad on 01/01/2021.
//

import Foundation

// MARK: - GetUserAlertsRequestModel
struct GetUserAlertsResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: [CashAlertModel]?
}

// MARK: - Datum
struct CashAlertModel: Codable {
    let alertID: Int?
    let name, alertTypeID, datumDescription: String?
    let isMultiple, isOperator: Bool?
    let alerts: [AlertModel]?
    
    enum CodingKeys: String, CodingKey {
        case alertID = "alertId"
        case name
        case alertTypeID = "alertTypeId"
        case datumDescription = "description"
        case isMultiple, isOperator, alerts
    }
}

// MARK: - Alert
struct AlertModel: Codable {
    let alertID: Int?
    let alertTypeID, id: String?
    let operatorTypeID: Int
    let amount: Double?
    let sms, email: String?
    let mobilePush: Bool?

    enum CodingKeys: String, CodingKey {
        case alertID = "alertId"
        case alertTypeID = "alertTypeId"
        case id
        case operatorTypeID = "operatorTypeId"
        case amount, sms, email, mobilePush
    }
}
