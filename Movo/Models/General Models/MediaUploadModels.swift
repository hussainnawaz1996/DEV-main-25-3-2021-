//
//  MediaUploadModels.swift
//  Movo
//
//  Created by Ahmad on 29/01/2021.
//

import Foundation


struct MediaUploadRequestModel: Codable {
    let type: Int
    enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

// MARK: - UploadMediaResponseModel
struct MediaUploadResponseModel: Codable {
    let isError: Bool
    let messages: String?
    let data: [UploadMedia]?
}

// MARK: - Datum
struct UploadMedia: Codable {
    let url, thumbURL: String?

    enum CodingKeys: String, CodingKey {
        case url
        case thumbURL = "thumbUrl"
    }
}
