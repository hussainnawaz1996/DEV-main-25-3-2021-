//
//  Common.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit
import Photos
import LocalAuthentication
import RNCryptor

class Common: NSObject {
    private let movoCashArray = ["Accounts", "Account Summary"]
    private let movoPayArray = ["Send Money", "Social Media", "History"]

    private let digitalBankingArray = ["My Bank Accounts", "Cash Out To Bank", "Direct Deposit", "Scheduled Transfers", "Transfer Activity"]
    private let eCheckbookArray = ["Make Payment", "Payment History", "Add Payees", "My Payees", "Scheduled Payments"]
    private let profileSettingsArray = ["Manage Profile", "Passcode", "MOVO Cash Alerts", "Biometric Authentication", "MoPro Support", "Terms & Conditions", "Privacy Policy"]
    
    
    private let movoCashIconsArray = [Icons.SideMenu.MovoCash.ACCOUNTS, Icons.SideMenu.MovoCash.ACCOUNTS_SUMMARY]
    private let movoPayIconsArray = [Icons.SideMenu.MovoPay.SEND_MONEY, Icons.SideMenu.MovoPay.SOCIAL_MEDIA, Icons.SideMenu.MovoPay.HISTORY]
    private let digitalBankingIconsArray = [Icons.SideMenu.DigitalBanking.MY_BANK_ACCOUNTS, Icons.SideMenu.DigitalBanking.CASH_OUT_TO_BANK, Icons.SideMenu.DigitalBanking.DIRECT_DEPOSIT, Icons.SideMenu.DigitalBanking.SCHEDULED_TRANSFERS, Icons.SideMenu.DigitalBanking.TRANSFER_ACTIVITY]
    private let eCheckBookIconsArray = [Icons.SideMenu.ECheckBook.ADD_PAYEES, Icons.SideMenu.ECheckBook.MAKE_PAYMENTS, Icons.SideMenu.ECheckBook.MY_PAYEES, Icons.SideMenu.ECheckBook.PAYMENT_HISTORY, Icons.SideMenu.ECheckBook.SCHEDULED_PAYMENTS]
    private let profileSettingIconsArray = [
        Icons.SideMenu.MyProfileSettings.MANAGE_PROFILE,
        Icons.SideMenu.MyProfileSettings.PASSCODE,
        Icons.SideMenu.MyProfileSettings.MOVO_CASH_ALERTS,
        Icons.SideMenu.MyProfileSettings.BIOMETRIC_AUTHENTICATION,
        Icons.SideMenu.MyProfileSettings.MO_PRO_SUPPORT,
        Icons.SideMenu.MyProfileSettings.TERMS_CONDITION,
        Icons.SideMenu.MyProfileSettings.PRIVACY_POLICY
    ]
    
    
    static let shared = Common()
    
    func getmovoCashArray() -> [UIImage] {
        return movoCashIconsArray
    }
    
    func getMovoCashIconsArray() -> [UIImage] {
        return movoCashIconsArray
    }
    
    func getMovoPayIconsArray() -> [UIImage] {
        return movoPayIconsArray
    }
    
    func getDigitalBankingIconsArray() -> [UIImage] {
        return digitalBankingIconsArray
    }
    
    func geteCheckbookIconsArray() -> [UIImage] {
        return eCheckBookIconsArray
    }
    
    func getProfileSettingIconsArray() -> [UIImage] {
        return profileSettingIconsArray
    }
    
    func getMovoCashTitlesArray() -> [String] {
        return movoCashArray
    }
    
    func getMovoPayTitlesArray() -> [String] {
        return movoPayArray
    }
    
    func getDigitalBankingTitlesArray() -> [String] {
        return digitalBankingArray
    }
    
    func getEheckbookTitlesArray() -> [String] {
        return eCheckbookArray
    }
    
    func getProfileSettingTitlesArray() -> [String] {
        return profileSettingsArray
    }
    
    
    func isPrimaryCard(model: CardModel) -> Bool {
//        return (model.programAbbreviation ?? "").lowercased().contains(K.MOVO)
        return model.isPrimaryCardSpecified ?? false
    }
    
    func getFormattedCardNumber(model: CardModel) -> String {
        let last4 = Common.shared.getLast4Digits(str: model.cardNumber ?? "")
        let result = (model.programAbbreviation ?? "") + " *" + last4
        return result
    }
    
    func getFormattedBankAccounNumber(model: AccountModel) -> String {
        let last4 = Common.shared.getLast4Digits(str: model.accountNumber ?? "")
        let result = (model.bankName ?? "") + " *" + last4
        return result
    }
    
    func getLast4Digits(str: String) -> String {
        if str.count > 4 {
            return String(str.suffix(4))
        } else {
            return str
        }

    }
    
    func saveCardAccounts() {
        
        let url = API.Card.getCardAccounts
        HooleyAPIGeneric<GetCardAccountsResponseModel>.fetchRequest(apiURL: url) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        CardAccountModelInfoStruct.instance.saveData(model: responseModel.data)
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
    
    func getcardholderprofile() -> Void {
        
        let url = API.Account.getcardholderprofile
        HooleyAPIGeneric<GetProfileHolderResponseModel>.fetchRequest(apiURL: url) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        if let model = responseModel.data {
                            if let profile = ProfileDetails.instance.getProfileDetails() {
//                                let str = shiping address1,city,stateIso2,Usa
                                let shippingAddress = model.billingAddress1 ?? ""
                                let shippingCity = model.billingCity ?? ""
                                let shippingStateISO = model.billingStateCode ?? ""
                                
                                if shippingAddress.isEmpty {
                                    profile.shippingAddress1 = ""
                                } else {
                                    profile.shippingAddress1 = "\(shippingAddress), \(shippingCity), \(shippingStateISO), USA"
                                }
                                ProfileDetails.instance.saveProfileDetails(instance: profile)
                            }
                        }
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
        
    class func devicePasscodeSet() -> Bool {
        let result = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return result
    }
    
    class func getImageFromAsset(asset: PHAsset, completionHandler: ((UIImage?) -> Void)?) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = false
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImageData(for: asset, options: options) { data, uti, orientation, info in
            guard let info = info else { return }
            
            if let error = info[PHImageErrorKey] as? Error {
                print("Cannot fetch data for GIF image: \(error)")
                completionHandler?(nil)
                return
            }
            
            if let isInCould = info[PHImageResultIsInCloudKey] as? Bool, isInCould {
                print("Cannot fetch data from cloud. Option for network access not set.")
                completionHandler?(nil)
                return
            }
            
            if let imageData = data {
                let pickedImage = UIImage(data: imageData) ?? Icons.RECTANGLE_PLACEHOLDER!
                completionHandler?(pickedImage)
            } else {
                completionHandler?(nil)
            }
        }
    }
    
    class func saveRememberedUsername(name: String) {
        let data: Data = Data(name.utf8)
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: UserDefaultKeys.userName)
        UserDefaults.standard.setValue(encryptedData, forKey: UserDefaultKeys.userName)
        
    }
    
    class func getRememberedUserName() -> String? {
        
        if let data = UserDefaults.standard.value(forKey: UserDefaultKeys.userName) as? Data {
            do {
                let originalData = try RNCryptor.decrypt(data: data, withPassword: UserDefaultKeys.userName)
                let str = String(decoding: originalData, as: UTF8.self)
                return str
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func saveUserPassword(str: String) {
        let data: Data = Data(str.utf8)
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: UserDefaultKeys.userPassword)
        UserDefaults.standard.setValue(encryptedData, forKey: UserDefaultKeys.userPassword)
        
    }
    
    class func getUserPassword() -> String? {
        
        if let data = UserDefaults.standard.value(forKey: UserDefaultKeys.userPassword) as? Data {
            do {
                let originalData = try RNCryptor.decrypt(data: data, withPassword: UserDefaultKeys.userPassword)
                let str = String(decoding: originalData, as: UTF8.self)
                return str
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
}
