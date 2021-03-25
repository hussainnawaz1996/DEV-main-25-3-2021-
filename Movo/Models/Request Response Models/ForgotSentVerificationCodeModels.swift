//
//  ForgotSentVerificationCodeModels.swift
//  Movo
//
//  Created by Ahmad on 28/12/2020.
//

import Foundation

// MARK: - ForgotSentVerificationCodeRequestModel
struct ForgotSentVerificationCodeRequestModel: Codable {
    let username, countryCode, phoneNumber: String?
}
