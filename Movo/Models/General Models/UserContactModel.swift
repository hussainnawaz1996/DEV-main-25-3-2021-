//
//  UserContactModel.swift
//  Movo
//
//  Created by Ahmad on 24/11/2020.
//

import Foundation

struct SyncUserContactsModel: Codable {
    var contacts: [UserContactModel]
}

struct UserContactModel: Codable, Hashable {
    static func == (lhs: UserContactModel, rhs: UserContactModel) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber)
    }
   
    var firstName: String
    var lastName, countryCode, phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, countryCode, phoneNumber
    }
}


struct ContactInfoStruct {
    static let instance = ContactInfoStruct()
    
    private let defaults = UserDefaults.standard
    
    func saveData(model:SyncUserContactsModel?) -> Void {
        if model != nil {
            let defaults = UserDefaults.standard
            defaults.set(try? PropertyListEncoder().encode(model), forKey: "ContactInfoStruct")
        }else{
            defaults.set(nil, forKey: "ContactInfoStruct")
        }

    }
    
    func fetchData() -> SyncUserContactsModel? {
        
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "ContactInfoStruct") as? Data{
            if let contactModel = try? PropertyListDecoder().decode(SyncUserContactsModel.self, from: data) {
                return contactModel
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
