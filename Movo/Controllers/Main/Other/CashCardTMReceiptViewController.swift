//
//  CashCardTMReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class CashCardTMReceiptViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var totalFebitAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var selectedCard: CardModel?
    var requestModel : AddCashCardRequestModel?
    private var feeVal : String?
    private var totalDebitAmount = 0.0

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.setAttributedTextWithSubscripts(str: "CASH Card")
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getServiceFee(referenceId: selectedCard?.referenceID ?? "", type: ServiceFeeType.GenerateCashCard.rawValue)
    }
    
    private func populateData(){
        
        if let card = selectedCard {
            
            let amountDouble = Double(requestModel?.amount ?? "0.0") ?? 0.0
            let feeDouble = Double(feeVal ?? "0.0") ?? 0.0

            totalDebitAmount = amountDouble + feeDouble
            
            cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: card)
            dateLbl.text = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString().getHistoryDateStr()
            amountLbl.text = "$" + "\((amountDouble))" + " USD"
            feeLbl.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2) + "USD"
            totalFebitAmountLbl.text = "$" + (totalDebitAmount).numberFormatter(digitAfterPoint: 2) + "USD"
            
            descriptionLbl.text = "NOTE: $" + feeDouble.numberFormatter(digitAfterPoint: 2) + "USD will be deducted from card account \(Common.shared.getFormattedCardNumber(model: card))"
        }
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        guard let model = requestModel else {
            return
        }
        
        let balance = Double(selectedCard?.balance ?? "0.0") ?? 0.0
        if totalDebitAmount > balance {
            self.alertMessage(title: K.ALERT, alertMessage: "You don't have sufficient balance.", action: nil)
            return
        }
        
        showProgressHud()
        HooleyPostAPIGeneric<AddCashCardRequestModel, AddCashCardResopnseModel>.postRequest(apiURL: API.Card.addCashCard, requestModel: model) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError {
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.alertMessage(title: K.SUCCESS, alertMessage: responseModel.data?.responseDesc ?? "", action: {
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

extension CashCardTMReceiptViewController {
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
