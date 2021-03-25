//
//  VerifyOTPModels.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import Foundation

// MARK: - VerifyOTPRequestModel
struct VerifyOTPRequestModel: Codable {
    let username, password: String
    let secretQuestionID: Int
    let secretAnswer, otp, sessionID, coversationID: String

    enum CodingKeys: String, CodingKey {
        case username, password
        case secretQuestionID = "secretQuestionId"
        case secretAnswer, otp
        case sessionID = "sessionId"
        case coversationID = "coversationId"
    }
}
