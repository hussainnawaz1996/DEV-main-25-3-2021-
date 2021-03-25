//
//  UpdatePasswordModels.swift
//  Movo
//
//  Created by Ahmad on 13/12/2020.
//

import Foundation

// MARK: - CashToBankTransferModel
struct UpdatePasswordRequestModel: Codable {
    let oldPassword, newPassword: String?
}
