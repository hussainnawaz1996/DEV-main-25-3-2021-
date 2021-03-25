//
//  AddressBookViewController.swift
//  Movo
//
//  Created by Ahmad on 24/11/2020.
//

import UIKit

class AddressBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    func configureCell(model: UserContactModel) {
        nameLbl.text = model.firstName + " " + model.lastName
        phoneNumberLbl.text = model.phoneNumber
    }
}

protocol AddressBookViewControllerDelegate:class {
    func selectedContact(contact: UserContactModel)
}

class AddressBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var contactsArray = [UserContactModel]()
    
    var delegate: AddressBookViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedContactsArray = ContactInfoStruct.instance.fetchData() {
            
            var contacts = savedContactsArray.contacts
            
            contacts.removeDuplicates()
            
            contacts = contacts.sorted(by: {$0.firstName.localizedCaseInsensitiveCompare($1.firstName ) == ComparisonResult.orderedAscending})
            contactsArray = contacts
            self.tableView.reloadData()
        }

    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressBookTableViewCell.className, for: indexPath) as! AddressBookTableViewCell
        cell.configureCell(model: contactsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        delegate?.selectedContact(contact: contactsArray[indexPath.row])
    }
}
