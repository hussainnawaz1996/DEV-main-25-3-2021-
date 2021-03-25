//
//  AccountSummaryTransactionTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class AccountSummaryTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: TransactionModel) {
        let amount = model.amount ?? 0.0
        let absoluteAmount = abs(amount)

        accountLbl.text = model.transactionDescription
        amountLbl.text = "$ \(absoluteAmount.numberFormatter(digitAfterPoint: 2))"
        dateLbl.text = model.transDate?.getLocalDate().getDisplayDate()
        
        amountStatusLabel.text = amount > 0 ? "+" : "-"
        amountStatusLabel.textColor = amount > 0 ? Colors.GREEN_COLOR : Colors.RED_COLOR
    }
    
}
