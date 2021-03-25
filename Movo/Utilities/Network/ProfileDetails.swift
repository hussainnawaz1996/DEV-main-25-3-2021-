//
//  HooleyProfileConfig.swift
//  hooley
//
//  Created by Usama Sadiq on 2/12/18.
//  Copyright © 2018 messagemuse. All rights reserved.
//

import Foundation
import os.log
import RNCryptor

struct ProfileKeys {
    
    static let userID = "userID"
    static let firstName = "firstName"
    static let lastName = "lastName"
//    static let profilePicture = "profilePicture"
    static let accessToken = "accessToken"
    static let userName = "userName"
    static let middleName = "middleName"
    static let profileUrl = "profileUrl"
    
    static let email = "email"
    static let lastLogin = "lastLogin"
    static let dateOfBirth = "dateOfBirth"
    static let genderId = "genderId"
    static let cellCountryCode = "cellCountryCode"
    static let cellPhoneNumber = "cellPhoneNumber"
    static let addressLine1 = "addressLine1"
    static let country = "country"
    static let state = "state"
    static let city = "city"
    static let zipCode = "zipCode"
    static let shippingAddress1 = "shippingAddress1"

}

class ProfileDetails: NSObject, NSCoding {
    
    static let instance = ProfileDetails()
    
    var userID:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var accessToken:String = ""
    var userName:String = ""
    var middleName:String = ""
    var profileUrl:String = ""

    var email:String = ""
    var lastLogin:String = ""
    var dateOfBirth:String = ""
    var genderId:String = ""
    var cellCountryCode:String = ""
    var cellPhoneNumber:String = ""
    var addressLine1: String = ""
    var country:String = ""
    var state:String = ""
    var city:String = ""
    var zipCode: String = ""
    var shippingAddress1: String = ""

    required convenience init?(coder aDecoder: NSCoder)
    {
        
        self.init()
        
        if let userid = aDecoder.decodeObject(forKey: ProfileKeys.userID) as? String {
            userID = userid
        }
        if let fname = aDecoder.decodeObject(forKey: ProfileKeys.firstName) as? String {
            firstName = fname
        }
        if let lname = aDecoder.decodeObject(forKey: ProfileKeys.lastName) as? String {
            lastName = lname
        }
        if let accessTokens = aDecoder.decodeObject(forKey: ProfileKeys.accessToken) as? String {
            accessToken = accessTokens
        }
        if let username = aDecoder.decodeObject(forKey: ProfileKeys.userName) as? String {
            userName = username
        }
        if let middlename = aDecoder.decodeObject(forKey: ProfileKeys.middleName) as? String {
            middleName = middlename
        }
        if let profieUrl = aDecoder.decodeObject(forKey: ProfileKeys.profileUrl) as? String {
            profileUrl = profieUrl
        }
        
        //new keys
        if let emil = aDecoder.decodeObject(forKey: ProfileKeys.email) as? String {
            email = emil
        }
        if let lstLogin = aDecoder.decodeObject(forKey: ProfileKeys.lastLogin) as? String {
            lastLogin = lstLogin
        }
        if let dob = aDecoder.decodeObject(forKey: ProfileKeys.dateOfBirth) as? String {
            dateOfBirth = dob
        }
        if let gnderId = aDecoder.decodeObject(forKey: ProfileKeys.genderId) as? String {
            genderId = gnderId
        }
        if let countryCode = aDecoder.decodeObject(forKey: ProfileKeys.cellCountryCode) as? String {
            cellCountryCode = countryCode
        }
        if let phoneNumber = aDecoder.decodeObject(forKey: ProfileKeys.cellPhoneNumber) as? String {
            cellPhoneNumber = phoneNumber
        }
        if let address = aDecoder.decodeObject(forKey: ProfileKeys.addressLine1) as? String {
            addressLine1 = address
        }
        if let cntry = aDecoder.decodeObject(forKey: ProfileKeys.country) as? String {
            country = cntry
        }
        if let st = aDecoder.decodeObject(forKey: ProfileKeys.state) as? String {
            state = st
        }
        if let cty = aDecoder.decodeObject(forKey: ProfileKeys.city) as? String {
            city = cty
        }
        if let zip = aDecoder.decodeObject(forKey: ProfileKeys.zipCode) as? String {
            zipCode = zip
        }
        if let shippingAddress = aDecoder.decodeObject(forKey: ProfileKeys.shippingAddress1) as? String {
            shippingAddress1 = shippingAddress
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userID, forKey: ProfileKeys.userID)
        aCoder.encode(firstName, forKey: ProfileKeys.firstName)
        aCoder.encode(lastName, forKey: ProfileKeys.lastName)
        aCoder.encode(accessToken, forKey: ProfileKeys.accessToken)
        aCoder.encode(userName, forKey: ProfileKeys.userName)
        aCoder.encode(middleName, forKey: ProfileKeys.middleName)
        aCoder.encode(profileUrl, forKey: ProfileKeys.profileUrl)

        //new keys
        aCoder.encode(email, forKey: ProfileKeys.email)
        aCoder.encode(lastLogin, forKey: ProfileKeys.lastLogin)
        aCoder.encode(dateOfBirth, forKey: ProfileKeys.dateOfBirth)
        aCoder.encode(genderId, forKey: ProfileKeys.genderId)
        aCoder.encode(cellCountryCode, forKey: ProfileKeys.cellCountryCode)
        aCoder.encode(cellPhoneNumber, forKey: ProfileKeys.cellPhoneNumber)
        aCoder.encode(addressLine1, forKey: ProfileKeys.addressLine1)
        aCoder.encode(country, forKey: ProfileKeys.country)
        aCoder.encode(state, forKey: ProfileKeys.state)
        aCoder.encode(city, forKey: ProfileKeys.city)
        aCoder.encode(zipCode, forKey: ProfileKeys.zipCode)
        aCoder.encode(shippingAddress1, forKey: ProfileKeys.shippingAddress1)

    }
    
    func getProfileDetails() -> ProfileDetails?
    {
        var profileDetails : ProfileDetails?
        if let data = UserDefaults.standard.object(forKey: "profileDetailsKey") as? Data
        {
            do {
                let originalData = try RNCryptor.decrypt(data: data, withPassword: EncryptionKeys.profileDataKey)
                profileDetails = NSKeyedUnarchiver.unarchiveObject(with: originalData) as? ProfileDetails
            } catch {
                print(error)
            }
        }
        return profileDetails
    }
    
    func saveProfileDetails(instance:ProfileDetails)
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: EncryptionKeys.profileDataKey)
        UserDefaults.standard.set(encryptedData, forKey: "profileDetailsKey")
    }
    
    func removeProfileDetails(instance:ProfileDetails) -> Void {
        UserDefaults.standard.removeObject(forKey: "profileDetailsKey")
        UserDefaults.standard.synchronize()
    }
    
    func removeProfileOnLogout() -> Void {
        UserDefaults.standard.removeObject(forKey: "profileDetailsKey")
        UserDefaults.standard.synchronize()
    }
    
    func clearAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
}
