//
//  MakePaymentReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 16/12/2020.
//

import UIKit

class MakePaymentReceiptViewController: UIViewController {
    
    @IBOutlet weak var payeeNameLbl: UILabel!
    @IBOutlet weak var fromAccountLbl: UILabel!
    @IBOutlet weak var paymentDateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var requestModel : MakePaymentRequestModel?
    var customModel : CustomMakePaymentModel?
    var isFromPayButton = false
    
    private var feeVal : String?
    private var totalDebitAmount = 0.0
    private var isEditFlow = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pCard = customModel?.selectedCard {
            getServiceFee(referenceId: pCard.referenceID ?? "", type: ServiceFeeType.makePayment.rawValue)
        }
    }
    
    private func populateData() {
        if let model = requestModel {
            
            let feeDouble = Double(feeVal ?? "0.0") ?? 0.0
            
            let amount = Double(model.amount ?? "0.0") ?? 0.0
            totalDebitAmount = feeDouble + amount
            
            let cardInfo = (customModel?.selectedCard?.programAbbreviation ?? "") + " *" +  Common.shared.getLast4Digits(str: customModel?.selectedCard?.cardNumber ?? "324234")
            
            payeeNameLbl.text = customModel?.payeeName ?? ""
            fromAccountLbl.text = cardInfo
            paymentDateLbl.text = model.paymentDate?.getHistoryDateStr()
            amountLbl.text = model.amount
            feeLbl.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2)
            totalAmountLbl.text = "$" +  totalDebitAmount.numberFormatter(digitAfterPoint: 2)
            descriptionLbl.text = "Note: $" + feeDouble.numberFormatter(digitAfterPoint: 2) + "USD fee will be deducted from card account \(cardInfo)"
            
            isEditFlow = (model.tansID?.isEmpty ?? false) ? false : true
            
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func rightButtonWasPressed(_ sender: UIButton) {
        
        if let model = requestModel {
            
            let balance = Double(customModel?.selectedCard?.balance ?? "0.0") ?? 0.0
            if totalDebitAmount > balance {
                self.alertMessage(title: K.ALERT, alertMessage: "You don't have sufficient balance.", action: nil)
                return
            }
            
            showProgressHud()
            HooleyPostAPIGeneric<MakePaymentRequestModel, MakePaymentResponseModel>.postRequest(apiURL: API.ECheckbook.makePayment, requestModel: model) { [weak self] (result) in
                guard let `self`  = self else { return }
                DispatchQueue.main.async {
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):
                        
                        if responseModel.isError{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.data?.responseDesc ?? "") {
                                self.navigationController?.popToRootViewController(animated: true)
                                
                                if self.isFromPayButton {
                                    NotificationCenter.default.post(name: .REFRESH_MY_PAYEES_SCREEN, object: nil)
                                } else {
                                    var userInfo = [String: ReloadHomeModel]()
                                    let model = ReloadHomeModel(screen: ReloadHome.ScreeenName.makePayment, index: 0)
                                    userInfo = [ReloadHome.key : model]
                                    NotificationCenter.default.post(name: .RELOAD_HOME_SCREEN, object: nil, userInfo: userInfo)
                                }
                            }
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

extension MakePaymentReceiptViewController {
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
