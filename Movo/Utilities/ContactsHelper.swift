//
//  ContactsHelper.swift
//  Movo
//
//  Created by Ahmad on 24/11/2020.
//

import Foundation
import Contacts

class ContactsHelper {
    
    static let instance = ContactsHelper()
    
    func getContactsPrivacyStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    private func findContactsOnBackgroundThread (completionHandler:@escaping (_ contacts:[CNContact]?)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async(execute: { () -> Void in
            let store = CNContactStore()
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey,CNContactOrganizationNameKey,CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactSocialProfilesKey, CNContactUrlAddressesKey, CNContactPostalAddressesKey, CNContactDatesKey] as [Any]
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .givenName
            
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                
                do {
                    try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                        if contact.phoneNumbers.count > 0 {
                            contacts.append(contact)
                        }
                    })
                } catch let e as NSError {
                    print(e.localizedDescription)
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(contacts)
                })
            case .denied:
                completionHandler(nil)
            case .restricted, .notDetermined:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        do {
                            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                                if contact.phoneNumbers.count > 0 {
                                    contacts.append(contact)
                                }
                            })
                        } catch let e as NSError {
                            print(e.localizedDescription)
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            completionHandler(contacts)
                        })
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(nil)
                        }
                    }
                }
            @unknown default:
                print("unknown default")
            }
        })
    }
    
    private func prepareUserContactList(contacts:[CNContact]) -> [UserContactModel] {

        var userContacts = [UserContactModel]()
        contacts.forEach { (contact) in

            var fullName : String = ""
            
            if let phoneNumber = contact.phoneNumbers.first{
                fullName = "\(contact.givenName) \(contact.familyName)"
                if fullName.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                    fullName = contact.organizationName
                }
                if fullName.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                    fullName = phoneNumber.value.stringValue
                }
            }
            
            let firstName = contact.givenName
            let lastName = contact.familyName
            
            var phoneNumbersArray = [String]()
            contact.phoneNumbers.forEach { (phone) in
                let str = phone.value.stringValue
                if !phoneNumbersArray.contains(str) {
                    phoneNumbersArray.append(str)
                }
            }
            phoneNumbersArray.forEach { (phone) in
                let info = phone.getMSISDNFromString2()
                let contactModel = UserContactModel(firstName: firstName, lastName: lastName, countryCode: info.countryCode ?? "", phoneNumber: info.phoneNumber ?? "")
                userContacts.append(contactModel)
            }
        }

        return userContacts
    }
    
    func syncLocalContacts() {
        findContactsOnBackgroundThread() { (response) in
            let localContactsList = self.prepareUserContactList(contacts: response ?? [])
            let model = SyncUserContactsModel(contacts: localContactsList)
            ContactInfoStruct.instance.saveData(model: model)

        }
    }
    
}


