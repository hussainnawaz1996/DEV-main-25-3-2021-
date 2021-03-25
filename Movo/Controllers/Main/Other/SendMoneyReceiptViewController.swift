//
//  SendMoneyReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 06/12/2020.
//

import UIKit

protocol SendMoneyReceiptViewControllerDelegate: class {
    func sendMoneySuccess()
}

class SendMoneyReceiptViewController: UIViewController {
    
    @IBOutlet weak var fromCardNumberLbl: UILabel!
    @IBOutlet weak var toCardNumberLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var totalDebitAmountLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var primaryCard : CardModel?
    var requestModel : ShareFundsRequestModel?
    
    var delegate: SendMoneyReceiptViewControllerDelegate?
    
    private var feeVal : String?
    private var totalDebitAmount = 0.0

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pCard = primaryCard {
            getServiceFee(referenceId: pCard.referenceID ?? "", type: ServiceFeeType.ShareFunds.rawValue)
        }
    }
    
    private func populateData(){
        let amount = requestModel?.amount ?? 0.0
        let feeDouble = Double(feeVal ?? "0.0") ?? 0.0
        totalDebitAmount = amount + feeDouble

        if let pCard = primaryCard {
            
            fromCardNumberLbl.text = Common.shared.getFormattedCardNumber(model: pCard)
            descriptionLbl.text = "NOTE: $\(feeDouble) USD will be deducted from card account \(Common.shared.getFormattedCardNumber(model: pCard))"

        }
        
        toCardNumberLbl.text = requestModel?.toPhoneOrEmail
        dateLbl.text = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString().getHistoryDateStr()
        amountLbl.text = "$\(amount)"
        feeLabel.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2)
        totalDebitAmountLabel.text = "$" + (totalDebitAmount).numberFormatter(digitAfterPoint: 2)
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
            HooleyPostAPIGeneric<ShareFundsRequestModel, ShareFundsResponseModel>.postRequest(apiURL: API.Card.shareFunds, requestModel: model) { [weak self] (result) in

                guard let `self`  = self else { return }

                DispatchQueue.main.async {
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):

                        if responseModel.isError {
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.alertMessage(title: K.SUCCESS, alertMessage: responseModel.data?.responseDesc ?? "", action: {
                                
                                self.navigationController?.popViewController(animated: true)
                                self.delegate?.sendMoneySuccess()
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

extension SendMoneyReceiptViewController {
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
