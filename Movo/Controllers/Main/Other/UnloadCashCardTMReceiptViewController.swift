//
//  UnloadCashCardTMReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class UnloadCashCardTMReceiptViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fromCardNumberLbl: UILabel!
    @IBOutlet weak var toCardNumberLbl: UILabel!
    @IBOutlet weak var transferDateLbl: UILabel!
    @IBOutlet weak var requestedAmountLbl: UILabel!
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var totalDebitAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var primaryCard : CardModel?
    var cashCard : CardModel?
    private var feeVal : String?

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.setAttributedTextWithSubscripts(str: "CASH Card")
        populateData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getServiceFee(referenceId: cashCard?.referenceID ?? "", type: ServiceFeeType.UnloadCashCard.rawValue)
    }
    
    private func populateData() {
        
        let amountDouble = Double(cashCard?.balance ?? "0.0") ?? 0.0
        let feeDouble = Double(feeVal ?? "0.0") ?? 0.0
        
        if let cCard = cashCard {
            fromCardNumberLbl.text = Common.shared.getFormattedCardNumber(model: cCard)
            descriptionLbl.text = "NOTE: $" + feeDouble.numberFormatter(digitAfterPoint: 2) + "USD will be deducted from card account \(Common.shared.getFormattedCardNumber(model: cCard))"
        }
        
        if let pCard = primaryCard {
            toCardNumberLbl.text = Common.shared.getFormattedCardNumber(model: pCard)
        }
        
        transferDateLbl.text = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString().getHistoryDateStr()
        requestedAmountLbl.text = "$" + amountDouble.numberFormatter(digitAfterPoint: 2)
        feeLbl.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2)
        totalDebitAmountLbl.text = "$" + (amountDouble + feeDouble).numberFormatter(digitAfterPoint: 2)
        
        


    }
    
    //MARK:- IBActions
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        let balanceDouble = Double(cashCard?.balance ?? "0.0") ?? 0.0
        let balanceStr = balanceDouble.numberFormatter(digitAfterPoint: 2)

        let requestModel = UnloadCashCardRequestModel(primaryReferenceID: primaryCard?.referenceID ?? "", cashCardReferenceID: cashCard?.referenceID ?? "", amount: balanceStr)
        
        showProgressHud()
        HooleyPostAPIGeneric<UnloadCashCardRequestModel, ReloadCashCardResponseModel>.postRequest(apiURL: API.Card.unloadCashCard, requestModel: requestModel) { [weak self] (result) in
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

extension UnloadCashCardTMReceiptViewController {
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
