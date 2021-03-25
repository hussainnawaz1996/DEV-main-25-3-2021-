//
//  CodeVerificationModels.swift
//  Movo
//
//  Created by Ahmad on 29/01/2021.
//

import Foundation


// MARK: - IsCodeVerifyRequestModel
struct IsCodeVerifyRequestModel: Codable {
    let code: String?
}

struct SendVerificationCodeRequestModel: Codable {
}
