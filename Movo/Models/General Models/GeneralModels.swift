//
//  GeneralModels.swift
//  Movo
//
//  Created by Ahmad on 24/01/2021.
//

import Foundation


struct CustomError: LocalizedError {
    var description: String?

    init(description: String) {
        self.description = description
    }
}

struct NotSuccessModel:Codable {
    let isError: Bool
    let messages: String?
}
