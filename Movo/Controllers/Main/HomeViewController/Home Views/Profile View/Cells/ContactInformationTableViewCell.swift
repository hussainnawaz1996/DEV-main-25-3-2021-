//
//  ContactInformationTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 27/12/2020.
//

import UIKit

class ContactInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    var stateButtonTapped : (()->())?
    var emailChanged: ((String)->())?
    var phoneChanged: ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(email:String, phone: String) {
        emailField.text = email
        phoneField.text = phone
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let str = sender.text ?? ""
        if sender == emailField {
            emailChanged?(str)
        } else {
            phoneChanged?(str)
        }
    }
    
    
}
