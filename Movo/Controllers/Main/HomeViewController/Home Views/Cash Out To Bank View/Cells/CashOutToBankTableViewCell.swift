//
//  CashOutToBankTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class CashOutToBankTableViewCell: UITableViewCell {

    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var amountField: Decimal2DigitsTextField!
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var scheduleDateButton: UIButton!
    @IBOutlet weak var scheduledView: UIView!
    
    var amountFieldTextChanged:((String)->())?
    var selectCardTapped:(()->())?
    var selectBankTapped:(()->())?
    var selectFrequencyTapped:(()->())?
    var scheduleDateButtonTapped:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(selectedCard: CardModel?, SelectedBank: AccountModel?, selectedFrequency:FrequencyType?, scheduleDate:String?, amount: String) {
        
        amountField.font = Fonts.ALLER_REGULAR_12
        amountField.text = amount
        
        if let model = selectedCard {
            let str = Common.shared.getFormattedCardNumber(model: model)
            cardLabel.text = str + "\n$" + "\(model.balance ?? "0.0")"
        } else {
            cardLabel.text = "Select From Card"
        }
        
        if let bank = SelectedBank {
            bankButton.setTitle(bank.bankName, for: .normal)
        } else {
            bankButton.setTitle("Select Bank Account", for: .normal)
        }
        
        if let type = selectedFrequency {
            if type == .once {
                frequencyButton.setTitle("One Time, Right Now", for: .normal)
                scheduledView.isHidden = true
            } else {
                frequencyButton.setTitle("One Time, Specific Date", for: .normal)
                scheduledView.isHidden = false
            }
        } else {
            scheduledView.isHidden = true
            frequencyButton.setTitle("Select Frequency", for: .normal)
        }
        
        if let str = scheduleDate {
            scheduleDateButton.setTitle(str.getHistoryDateStr(), for: .normal)
        } else {
            scheduleDateButton.setTitle("Schedule Date", for: .normal)
        }
    }
    
    @IBAction func amountFieldDidChange(_ sender: UITextField) {
        amountFieldTextChanged?(sender.text ?? "0")
    }
    
    @IBAction func selectFromCardButtonWasPressed(_ sender: UIButton) {
        selectCardTapped?()
    }
    
    @IBAction func selectBankAccountButtonWasPresed(_ sender: UIButton) {
        selectBankTapped?()
    }
    
    @IBAction func selectFrequencyButtonWasPresed(_ sender: UIButton) {
        selectFrequencyTapped?()
    }
    
    @IBAction func scheduleDateButtonWasPressed(_ sender: UIButton) {
        scheduleDateButtonTapped?()
    }

}
