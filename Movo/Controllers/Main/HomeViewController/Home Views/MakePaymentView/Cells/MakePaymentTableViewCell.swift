//
//  MakePaymentTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class MakePaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var payeeButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    
    var payeeButtonTapped:(()->())?
    var cardButtonTapped:(()->())?
    var amountTextChanged:((String)->())?
    var dateButtonTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(SelectedPayee: PayeeModel?, selectedCard: CardModel?, scheduleDate:String?, amount: String) {
        
        amountField.font = Fonts.ALLER_REGULAR_12
        amountField.text = amount
        
        if let model = selectedCard {
            let str = Common.shared.getFormattedCardNumber(model: model)
            cardLbl.text = str + "\n$" + "\(model.balance ?? "0.0")"
        } else {
            cardLbl.text = "Select From Card"
        }
        
        if let payee = SelectedPayee {
            payeeButton.setTitle(payee.payeeName, for: .normal)
        } else {
            payeeButton.setTitle("Please Select Payee", for: .normal)
        }
        
        if let str = scheduleDate {
            dateButton.setTitle(str.getHistoryDateStr(), for: .normal)
        } else {
            dateButton.setTitle("Please Enter Payment Date", for: .normal)
        }
    }
    
    @IBAction func payeeButtonWasPressed(_ sender: UIButton) {
        payeeButtonTapped?()
    }
    
    @IBAction func cardButtonWasPressed(_ sender: UIButton) {
        cardButtonTapped?()
    }
    
    @IBAction func dateButtonWasPressed(_ sender: UIButton) {
        dateButtonTapped?()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let str = sender.text ?? ""
        amountTextChanged?(str)
    }
}
