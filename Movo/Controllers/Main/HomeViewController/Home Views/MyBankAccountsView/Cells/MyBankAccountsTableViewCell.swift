//
//  MyBankAccountsTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 11/12/2020.
//

import UIKit

class MyBankAccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: AccountModel) {
        let title = model.bankName ?? ""
        let last4DigitCardNumber = String(model.accountNumber?.suffix(4) ?? "")
        accountNumberLbl.text = title + " *" + last4DigitCardNumber
        
        typeLbl.text = model.accountType == AccountType.cardToBank.rawValue ? "Type: Card to Bank" : "Type: Bank To Card"
        
        statusLbl.text = model.status
    }
    
}
