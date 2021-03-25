//
//  UploadProfilePictureModels.swift
//  Movo
//
//  Created by Ahmad on 17/01/2021.
//

import Foundation

// MARK: - UpdateProfilePictureRequestModel
struct UpdateProfilePictureRequestModel: Codable {
    let profilePicture, profilePictureThumb: String?
}
