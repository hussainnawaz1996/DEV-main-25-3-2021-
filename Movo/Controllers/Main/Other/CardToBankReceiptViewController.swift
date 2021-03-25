//
//  CardToBankReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import UIKit

class CardToBankReceiptViewController: UIViewController {

    @IBOutlet weak var fromCardLabel: UILabel!
    @IBOutlet weak var toAccountLabel: UILabel!
    @IBOutlet weak var transferDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var totalDebitAmountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    var requestModel: CashToBankTransferRequestModel?
    var selectedCard: CardModel?
    var selectedBank: AccountModel?
    
    private var feeVal : String?
    private var totalDebitAmount = 0.0

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pCard = selectedCard {
            getServiceFee(referenceId: pCard.referenceID ?? "", type: ServiceFeeType.makePayment.rawValue)
        }
    }
    
    private func populateData() {
        if let model = requestModel {
            
            let feeDouble = Double(feeVal ?? "0.0") ?? 0.0
            totalDebitAmount = (Double(model.amount ?? "0.0") ?? 0.0) + feeDouble

            if let card = selectedCard {
                fromCardLabel.text = Common.shared.getFormattedCardNumber(model: card)
                descriptionLbl.text = "NOTE: $\(totalDebitAmount) USD will be deducted from card \(Common.shared.getFormattedCardNumber(model: card))"

            }
            
            if let bank = selectedBank {
                toAccountLabel.text = Common.shared.getFormattedBankAccounNumber(model: bank)
            }
            
            transferDateLabel.text = model.transferDate?.getHistoryDateStr()
            amountLabel.text = model.amount
            feeLabel.text = "$" + feeDouble.numberFormatter(digitAfterPoint: 2)
            
            totalDebitAmountLbl.text = "\(totalDebitAmount)"
            
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ConfirmButtonWasPressed(_ sender: UIButton) {
        if let model = requestModel {
            
            let balance = Double(selectedCard?.balance ?? "0.0") ?? 0.0
            if totalDebitAmount > balance {
                self.alertMessage(title: K.ALERT, alertMessage: "You don't have sufficient balance.", action: nil)
                return
            }
            
            showProgressHud()
            HooleyPostAPIGeneric<CashToBankTransferRequestModel, CashToBankTransferResponseModel>.postRequest(apiURL: API.Banking.c2btransfer, requestModel: model) { [weak self] (result) in
                guard let `self`  = self else { return }
                DispatchQueue.main.async {
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):
                        
                        if responseModel.isError{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.alertMessage(title: K.SUCCESS, alertMessage: responseModel.data?.responseDesc ?? "") {
                                self.navigationController?.popToRootViewController(animated: true)
                                                                
                                var userInfo = [String: ReloadHomeModel]()
                                let model = ReloadHomeModel(screen: ReloadHome.ScreeenName.scheduleTransfer, index: 0)
                                userInfo = [ReloadHome.key : model]
                                NotificationCenter.default.post(name: .RELOAD_HOME_SCREEN, object: nil, userInfo: userInfo)
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



extension CardToBankReceiptViewController {
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
