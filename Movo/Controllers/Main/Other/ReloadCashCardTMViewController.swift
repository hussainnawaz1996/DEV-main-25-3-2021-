//
//  ReloadCashCardTMViewController.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class ReloadCashCardTMViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var primaryAccountNumberLbl: UILabel!
    @IBOutlet weak var primaryAccountBalanceLbl: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var cashCardAccountNumberLbl: UILabel!
    @IBOutlet weak var cashCardBalanceLbl: UILabel!
    
    var primaryCard: CardModel?
    var cashCard: CardModel?
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.setAttributedTextWithSubscripts(str: "CASH Card")

        if let pCard = primaryCard {
            primaryAccountNumberLbl.text = Common.shared.getFormattedCardNumber(model: pCard)
            primaryAccountBalanceLbl.text = "$" + (pCard.balance ?? "0.0") + "USD"
        }
        
        if let cCard = cashCard {
            cashCardAccountNumberLbl.text = Common.shared.getFormattedCardNumber(model: cCard)
            cashCardBalanceLbl.text = "$" + (cCard.balance ?? "0.0") + "USD"
        }
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        
        let amount = amountField.text ?? ""

        let amountVal = Double(amount) ?? 0.0
        let balanceVal = Double(primaryCard?.balance ?? "0.0") ?? 0.0
        if amount.isEmpty || amountVal == 0.0 {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter amount to send", action: nil)
            return
        }
        
        if amountVal > balanceVal {
            self.alertMessage(title: K.ALERT, alertMessage: "Insufficient balance", action: nil)
            return
        }
        
        let primaryReferenceId = primaryCard?.referenceID ?? ""
        let cashCardReferenceId = cashCard?.referenceID ?? ""

        let requestModel = ReloadCashCardRequestModel(primaryReferenceID: primaryReferenceId, cashCardReferenceID: cashCardReferenceId, amount: amountVal.numberFormatter(digitAfterPoint: 2))

        Router.shared.openReloadCashCardTMReceiptViewController(primaryCard: primaryCard, cashCard: cashCard, requestModel: requestModel, controller: self)
                
    }
    
}
