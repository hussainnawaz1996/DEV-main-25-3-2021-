//
//  BankAccountReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 07/12/2020.
//

import UIKit

class BankAccountReceiptViewController: UIViewController {
    
    
    @IBOutlet weak var legalNameLbl: UILabel!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var routingNumberLbl: UILabel!
    @IBOutlet weak var accountTypeLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    
    @IBOutlet weak var deleteButton: RedBGButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private var isEditFlow = false
    var requestModel : CreateBankAccountRequestModel?
    
    var delegate: SendMoneyReceiptViewControllerDelegate?
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = requestModel {
            let isCheckingAccount = model.isCheckingAccount ?? false
            legalNameLbl.text = model.legalName
            bankNameLbl.text = model.bankName
            routingNumberLbl.text = model.routingNumber
            accountTypeLbl.text = isCheckingAccount ? "Checking Account" : "Saving Account"
            accountNumberLbl.text = model.bankAccountNumber
            nickNameLbl.text = model.nickName
            
            isEditFlow = (model.bankSerialNumberIfEdit?.isEmpty ?? false) ? false : true
            
        }
        
        
        if isEditFlow {
            deleteButton.isHidden = false
            rightButton.setTitle("Edit", for: .normal)
        } else {
            deleteButton.isHidden = true
            rightButton.setTitle("Confirm", for: .normal)
        }
        
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        
        if isEditFlow {
            let accountType : AccountType = (requestModel?.accountType ?? 1) == 1 ? AccountType.cardToBank : AccountType.bankToCard
            Router.shared.openCreateNewBankAccountViewController(requestModel: requestModel, accountType: accountType , controller: self)
        } else {
            
            if let model = requestModel {
                
                showProgressHud()
                HooleyPostAPIGeneric<CreateBankAccountRequestModel, CreateBankAccountResponseModel>.postRequest(apiURL: API.Banking.createbankaccount, requestModel: model) { [weak self] (result) in
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
                                    NotificationCenter.default.post(name: .REFRESH_MY_BANK_ACCOUNT_SCREEN, object: nil)
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
    
    @IBAction func deleteButtonWasPressed(_ sender: RedBGButton) {
        
        showProgressHud()
        
        let url = API.Banking.removebankaccount + "/\(requestModel?.bankSerialNumberIfEdit ?? "")"
        HooleyAPIGeneric<RemoveBankAccountResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.data?.responseDesc ?? "") {
                            NotificationCenter.default.post(name: .REFRESH_MY_BANK_ACCOUNT_SCREEN, object: nil)
                            self.navigationController?.popToRootViewController(animated: true)
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
