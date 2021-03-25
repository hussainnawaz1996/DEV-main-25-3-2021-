//
//  CreateNewBankAccountViewController.swift
//  Movo
//
//  Created by Ahmad on 06/12/2020.
//

import UIKit

class CreateNewBankTableViewCell : UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var legalNameTextField: UITextField!
    @IBOutlet weak var bankNameTextFie: UITextField!
    @IBOutlet weak var routingNumberField: UITextField!
    @IBOutlet weak var confirmRoutingNumberField: UITextField!
    @IBOutlet weak var accountTypeField: UITextField!
    
    @IBOutlet weak var accountNumberField: UITextField!
    @IBOutlet weak var confirmAccountNumberField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    
    var pickerButtonTapped:(()->())?
    var infoButtonTapped:(()->())?
    private var index = -1
    
    var textChanged:((Int, String)->())?
    
    func configureCell(requestModel : CreateBankAccountRequestModel?) {
        
        selectionStyle = .none
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            legalNameTextField.text = profile.firstName + " " + profile.lastName
        }
        
        if let model = requestModel {
            legalNameTextField.text = model.legalName
            bankNameTextFie.text = model.bankName
            routingNumberField.text = model.routingNumber
            confirmRoutingNumberField.text = model.routingNumber
            accountTypeField.text = (model.isCheckingAccount ?? false) ? "Checking Account" : "Saving Account"
            accountNumberField.text = model.bankAccountNumber
            confirmAccountNumberField.text = model.bankAccountNumber
            nickNameField.text = model.nickName
        }
//        else {
            
//        }
      
    }
    
    @IBAction func infoButonWasPressed(_ sender: UIButton) {
        infoButtonTapped?()
    }
    
    @IBAction func pickerButtonWasPressed(_ sender: UIButton) {
        pickerButtonTapped?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
                        
        if textField == routingNumberField || textField == confirmRoutingNumberField {
            if textField.text!.count < 9 {
                return true
            }else{
                return false
            }
        }
        
        if textField == accountNumberField || textField == confirmAccountNumberField {
            if textField.text!.count < 16 {
                return true
            }else{
                return false
            }
        }
        
        if textField == nickNameField {
            if string == " " {
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let str = sender.text ?? ""
        if sender == legalNameTextField {
            textChanged?(0,str)
        } else if sender == bankNameTextFie {
            textChanged?(1,str)
        } else if sender == routingNumberField {
            textChanged?(2,str)
        } else if sender == confirmRoutingNumberField {
            textChanged?(3,str)
        } else if sender == accountNumberField {
            textChanged?(5, str)
        } else if sender == confirmAccountNumberField {
            textChanged?(6, str)
        } else if sender == nickNameField {
            textChanged?(7, str)
        }
    }
    
}

class CreateNewBankAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarButton: UIButton!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    var selectedAccountType : AccountType = .cardToBank
    var requestModel : CreateBankAccountRequestModel?

    private let buttonImages = [nil, nil, Icons.INFO_ICON, nil, Icons.ARROW_RIGHT_ICON, Icons.INFO_ICON, nil, nil]
    
    private var legalName = ""
    private var bankName = ""
    private var routingNumber = ""
    private var confirmRoutingNumber = ""
    private var accountTypeStr = ""
    private var accountNumber = ""
    private var confirmAccountNumber = ""
    private var nickName = ""
    private var comments = ""
    private var isCheckingAccount = false
    
    private var isEditFlow = false
    
    //MARK:- View life cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CashOutToBankCommentsTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankCommentsTableViewCell.className)
        tableView.tableFooterView = UIView()
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            legalName = profile.firstName + " " + profile.lastName
        }
        
        if let model = requestModel {
            legalName = model.legalName ?? ""
            bankName = model.bankName ?? ""
            routingNumber = model.routingNumber ?? ""
            confirmRoutingNumber = model.routingNumber ?? ""
            accountTypeStr = (model.isCheckingAccount ?? false) ? "Checking Account" : "Saving Account"
            isCheckingAccount = model.isCheckingAccount ?? false
            accountNumber = model.bankAccountNumber ?? ""
            confirmAccountNumber = model.bankAccountNumber ?? ""
            nickName = model.nickName ?? ""
            comments = model.comments ?? ""
        }
        
        isEditFlow = requestModel == nil ? false : true
        
        if isEditFlow {
            rightBarButton.setTitle("Confirm", for: .normal)
            subtitleLbl.isHidden = true
        } else {
            rightBarButton.setTitle("Next", for: .normal)
            subtitleLbl.isHidden = false
        }
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        if legalName.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter legal name", action: nil)
            return
        }
        
        if bankName.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter bank name", action: nil)
            return
        }
        
        if routingNumber.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter routing number", action: nil)
            return
        }
        
        if confirmRoutingNumber.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please confirm routing number", action: nil)
            return
        }
        
        if routingNumber != confirmRoutingNumber {
            alertMessage(title: K.ALERT, alertMessage: "routing numbers do not match", action: nil)
            return
        }
        
        if accountTypeStr.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please select account type", action: nil)
            return
        }
        
        if accountNumber.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter account number", action: nil)
            return
        }
        
        if confirmAccountNumber.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please confirm account number", action: nil)
            return
        }
        
        if accountNumber != confirmAccountNumber {
            alertMessage(title: K.ALERT, alertMessage: "account numbers do not match", action: nil)
            return
        }
        
        if nickName.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter nick name", action: nil)
            return
        }
             
        let serialNumber = isEditFlow ? requestModel?.bankSerialNumberIfEdit ?? "" : ""
        
        let requestModel = CreateBankAccountRequestModel(bankSerialNumberIfEdit: serialNumber, accountType: selectedAccountType.rawValue, legalName: legalName, bankName: bankName, routingNumber: routingNumber, isCheckingAccount: isCheckingAccount, bankAccountNumber: accountNumber, nickName: nickName, comments: comments)
        
        if isEditFlow {
            editBankAccountAPICall(requestModel: requestModel)
        } else {
            Router.shared.openBankAccountReceiptViewController(requestModel: requestModel, controller: self)
        }
    }
   
    private func editBankAccountAPICall(requestModel: CreateBankAccountRequestModel) {
        showProgressHud()
        HooleyPostAPIGeneric<CreateBankAccountRequestModel, CreateBankAccountResponseModel>.postRequest(apiURL: API.Banking.editbankaccount, requestModel: requestModel) { [weak self] (result) in
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

extension CreateNewBankAccountViewController :  UITableViewDelegate, UITableViewDataSource {
    //MARK:- UITableView delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateNewBankTableViewCell.className, for: indexPath) as! CreateNewBankTableViewCell
            cell.configureCell(requestModel: requestModel)
            cell.pickerButtonTapped = {
                let strArray = ["Checking Account", "Saving Account"]
                
                Router.shared.openDataPickerPopUpVC(content: strArray, title: "", selectedValue: strArray[0], controller: self, dataPickedHandler: { (index, value) in
                    DispatchQueue.main.async {
                        cell.accountTypeField.text = value
                        self.accountTypeStr = value
                        self.isCheckingAccount = index == 0
                    }
                })
            }
            
            cell.infoButtonTapped = {
                Router.shared.openBankAccountInfoPopupVC(controller: self)
            }
            
            cell.textChanged = { index, value in
                switch index {
                case 0:
                    self.legalName = value
                case 1:
                    self.bankName = value
                case 2:
                    self.routingNumber = value
                case 3:
                    self.confirmRoutingNumber = value
                case 5:
                    self.accountNumber = value
                case 6:
                    self.confirmAccountNumber = value
                case 7:
                    self.nickName = value
                default:
                    break
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CashOutToBankCommentsTableViewCell.className, for: indexPath) as! CashOutToBankCommentsTableViewCell
            cell.selectionStyle = .none
            cell.textView.text = comments
            
            cell.textChanged = { str in
                self.comments = str
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 400
        } else {
             return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}
