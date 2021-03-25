//
//  CashCardTMEnterInfoViewController.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class CashCardTMEnterInfoViewController:  UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var commentsField: UITextField!
    
    var selectedCard: CardModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = selectedCard {
            cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: model)
            let balanceStr = model.balance?.get2DigitDecimalString() ?? "0.00"
            balanceLbl.text = "Balance: $" + (balanceStr) + "USD"
        }
        
        titleLbl.setAttributedTextWithSubscripts(str: "CASH Card")
        
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        addCashCardAPICall()
    }
    
    func addCashCardAPICall() {
        let amount = amountField.text ?? ""
        let amountVal = Double(amount) ?? 0.0
        let balanceVal = Double(selectedCard?.balance ?? "0.0") ?? 0.0
        let nameVal = commentsField.text ?? ""

        if amount.isEmpty || amountVal == 0.0 {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter amount to send", action: nil)
            return
        }
        
        if amountVal > balanceVal {
            self.alertMessage(title: K.ALERT, alertMessage: Alerts.NOT_AVAILABLE_BALANCE, action: nil)
            return
        }
        
        if nameVal.isEmpty {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter name to send", action: nil)
            return
        }
        
        let referenceId = selectedCard?.referenceID ?? ""
        
        let requestModel = AddCashCardRequestModel(fromReferenceID: referenceId, amount: amountVal.numberFormatter(digitAfterPoint: 2), nameOnCard: nameVal)
        Router.shared.openCashCardTMReceiptViewController(selectedCard: selectedCard, requestModel: requestModel, controller: self)
    }
}
