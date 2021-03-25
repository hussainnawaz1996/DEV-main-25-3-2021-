//
//  CustomSignupModel.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit

struct CustomSignupModel {
    var email: String
    var phoneNumber: String
    var photosModel: PhotosModel?
    var user3rdScreenModel : User3rdScreenModel?
}

struct PhotosModel {
    var frontImage : UIImage?
    var backImage : UIImage?
    var selfieImage : UIImage?
}

struct User3rdScreenModel {
    var userName: String?
    var password: String?
    var selectedSecretQuestion: NameIdModel?
    var answer: String?
    var isRememberMe : Bool?
}
