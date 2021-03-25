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
    
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var totalDebitAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var primaryCard : CardModel?
    var cashCard : CardModel?
    var requestModel : ReloadCashCardRequestModel?
    private var totalDebitAmount = 0.0
    private var feeVal : String?

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.setAttributedTextWithSubscripts(str: "CASH Card")
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getServiceFee(referenceId: primaryCard?.referenceID ?? "", type: ServiceFeeType.ReloadCashCard.rawValue)
    }
    
    private func populateData() {
        
        let amountDouble = Double(requestModel?.amount ?? "0.0") ?? 0.0
        let feeDouble = Double(feeVal ?? "0.0") ?? 0.0
        
        totalDebitAmount = amountDouble + feeDouble
        
        if let pCard = primaryCard {
            fromCardNumberLbl.text = Common.shared.getFormattedCardNumber(model: pCard)
            descriptionLbl.text = "NOTE: $\(feeDouble.numberFormatter(digitAfterPoint: 2)) USD will be deducted from card account \(Common.shared.getFormattedCardNumber(model: pCard))"
        }
        
        if let cCard = cashCard {
            toCardNumberLbl.text = Common.shared.getFormattedCardNumber(model: cCard)
        }
        
        transferDateLbl.text = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString().getHistoryDateStr()
        transferAmountLbl.text = "$" + amountDouble.numberFormatter(digitAfterPoint: 2)
        
        feeLbl.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2)
        totalDebitAmountLbl.text = "$" + (totalDebitAmount).numberFormatter(digitAfterPoint: 2)
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        if let model = requestModel {
            
            let balance = Double(primaryCard?.balance ?? "0.0") ?? 0.0
            if totalDebitAmount > balance {
                self.alertMessage(title: K.ALERT, alertMessage: "You don't have sufficient balance.", action: nil)
                return
            }
            
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
                        let err = CustomError(description: (error as? CustomError)?.description ?? "")
                        self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                    }
                }
            }
        }
    }
}

extension ReloadCashCardTMReceiptViewController {
    private func getServiceFee(referenceId: String, type: Int) {
        
        showProgressHud()
        
        let url = API.Common.getservicefee + "/\(referenceId)" + "/\(type)"
        HooleyAPIGeneric<GetFeeResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError {
                        print(responseModel.messages ?? "")
                    }else{
                        self.feeVal = responseModel.data?.requestedServiceFee ?? "0.0"
                        self.populateData()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                    self.getServiceFee(referenceId: referenceId, type: type)
                }
            }
        }
    }
}
