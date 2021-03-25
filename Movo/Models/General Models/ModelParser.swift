//
//  ModelParser.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import UIKit

class ModelParser {
    
    static func parseLoginModel(model:LoginModel?, password: String) -> Void {
        
        Common.saveUserPassword(str: password)

        if let responseModel = model {
            
            if let profile = ProfileDetails.instance.getProfileDetails() {
                profile.accessToken = responseModel.token ?? ""
                profile.email = responseModel.email ?? ""
                profile.firstName = responseModel.firstName ?? ""
                profile.lastName = responseModel.lastName ?? ""
                profile.userName = responseModel.username ?? ""
                profile.middleName = responseModel.middleName ?? ""
                profile.userID = responseModel.userID ?? ""
                profile.profileUrl = responseModel.profilePictureThumb ?? ""

                if responseModel.lastLogin == nil {
                    profile.lastLogin = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
                } else {
                    profile.lastLogin = responseModel.lastLogin ?? ""
                }
                if let accountInfo = responseModel.accountInfo {
                    profile.dateOfBirth = accountInfo.dateOfBirth ?? ""
                    profile.genderId = String(accountInfo.genderID ?? 1)
                    profile.cellCountryCode = accountInfo.cellCountryCode ?? ""
                    profile.cellPhoneNumber = accountInfo.cellPhoneNumber ?? ""
                    profile.addressLine1 = accountInfo.addressLine1 ?? ""
                    profile.country = accountInfo.country ?? ""
                    profile.state = accountInfo.state ?? ""
                    profile.city = accountInfo.city ?? ""
                    profile.zipCode = accountInfo.zipCode ?? ""
                }
                
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isUserLogin)

                ProfileDetails.instance.saveProfileDetails(instance: profile)
            } else {
                let profile = ProfileDetails.instance
                profile.accessToken = responseModel.token ?? ""
                profile.email = responseModel.email ?? ""
                profile.firstName = responseModel.firstName ?? ""
                profile.lastName = responseModel.lastName ?? ""
                profile.userName = responseModel.username ?? ""
                profile.middleName = responseModel.middleName ?? ""
                profile.userID = responseModel.userID ?? ""
                profile.profileUrl = responseModel.profilePictureThumb ?? ""
                
                if responseModel.lastLogin == nil {
                    profile.lastLogin = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
                } else {
                    profile.lastLogin = responseModel.lastLogin ?? ""
                }
                if let accountInfo = responseModel.accountInfo {
                    profile.dateOfBirth = accountInfo.dateOfBirth ?? ""
                    profile.genderId = String(accountInfo.genderID ?? 1)
                    profile.cellCountryCode = accountInfo.cellCountryCode ?? ""
                    profile.cellPhoneNumber = accountInfo.cellPhoneNumber ?? ""
                    profile.addressLine1 = accountInfo.addressLine1 ?? ""
                    profile.country = accountInfo.country ?? ""
                    profile.state = accountInfo.state ?? ""
                    profile.city = accountInfo.city ?? ""
                    profile.zipCode = accountInfo.zipCode ?? ""
                }
                
                UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isUserLogin)

                ProfileDetails.instance.saveProfileDetails(instance: profile)
                
                Common.shared.saveCardAccounts()
                Common.shared.getcardholderprofile()
            }
        }
    }
}






struct CardAccountModelInfoStruct {
    static let instance = CardAccountModelInfoStruct()
    
    private let defaults = UserDefaults.standard
    
    func saveData(model:CardAccountModel?) -> Void {
        if model != nil {
            let defaults = UserDefaults.standard
            defaults.set(try? PropertyListEncoder().encode(model), forKey: "CardAccountModelInfoStruct")
        }else{
            defaults.set(nil, forKey: "CardAccountModelInfoStruct")
        }

    }
    
    func fetchData() -> CardAccountModel? {
        
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "CardAccountModelInfoStruct") as? Data{
            if let staticModel = try? PropertyListDecoder().decode(CardAccountModel.self, from: data) {
                return staticModel
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}







struct BiometricLoginInfoStruct {
    
    static let instance = BiometricLoginInfoStruct()
    
    private let defaults = UserDefaults.standard
    
    func saveData(model:BiometricLoginModel) -> Void {
        
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(model), forKey: "BiometricLoginInfoStruct")
        
    }
    
    func fetchData() -> BiometricLoginModel? {
        
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "BiometricLoginInfoStruct") as? Data{
            if let staticModel = try? PropertyListDecoder().decode(BiometricLoginModel.self, from: data) {
                return staticModel
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
