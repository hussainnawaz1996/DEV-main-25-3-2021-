//
//  VerifyOTPModels.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import Foundation

// MARK: - VerifyOTPRequestModel
struct VerifyDocumentRequestModel: Codable {
    let sessionID: String
    let documents: [DocumentModel]?

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case documents
    }
}

// MARK: - Document
struct DocumentModel: Codable {
    let documentType: Int
    let base64: String
}
