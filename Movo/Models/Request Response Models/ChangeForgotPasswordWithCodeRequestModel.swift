//
//  ChangeForgotPasswordWithCodeRequestModel.swift
//  Movo
//
//  Created by Ahmad on 28/12/2020.
//

import Foundation

// MARK: - ChangeForgotPasswordWithCodeRequestModel
struct ChangeForgotPasswordWithCodeRequestModel: Codable {
    let username, phoneNumber, newPassword, code: String?
}
