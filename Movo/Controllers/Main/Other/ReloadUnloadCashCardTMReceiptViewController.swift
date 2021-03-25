//
//  ReloadUnloadCashCardTMReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class ReloadCashCardTMReceiptViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fromCardNumberLbl: UILabel!
    @IBOutlet weak var toCardNumberLbl: UILabel!
    @IBOutlet weak var transferDateLbl: UILabel!
    @IBOutlet weak var transferAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var primaryCard : CardModel?
    var cashCard : CardModel?
    var requestModel : ReloadCashCardRequestModel?
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pCard = primaryCard {
            let last4DigitCardNumber = String(pCard.cardNumber?.suffix(4) ?? "")
            fromCardNumberLbl.text = (pCard.programAbbreviation ?? "") + " *" + last4DigitCardNumber
            
            descriptionLbl.text = "NOTE: $0.00 USD will be deducted from card account \((pCard.programAbbreviation ?? "") + " *" + last4DigitCardNumber)"
            
        }
        
        if let cCard = cashCard {
            let last4DigitCardNumber = String(cCard.cardNumber?.suffix(4) ?? "")
            toCardNumberLbl.text = (cCard.programAbbreviation ?? "") + " *" + last4DigitCardNumber
        }
        
        transferDateLbl.text = Date().convertTimeToUTC().getHistoryDateStr()
        transferAmountLbl.text = "\(requestModel?.amount ?? 0.0)"
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        if let model = requestModel {
            showProgressHud()
            HooleyPostAPIGeneric<ReloadCashCardRequestModel, ReloadCashCardResponseModel>.postRequest(apiURL: API.Card.reloadCashCard, requestModel: model) { [weak self] (result) in
                guard let `self`  = self else { return }
                DispatchQueue.main.async {
                    
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):
                        
                        if responseModel.isError {
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.data?.responseDesc ?? "", action: {
                                self.navigationController?.popToRootViewController(animated: true)
                                NotificationCenter.default.post(name: .REFRESH_CASH_CARD_SCREEN, object: nil)
                            })
                        }
                        
                    case .failure(let error):
                        self.alertMessage(title: K.ALERT, alertMessage: error.localizedDescription, action: nil)
                    }
                }
            }
        }
    }
    
}
