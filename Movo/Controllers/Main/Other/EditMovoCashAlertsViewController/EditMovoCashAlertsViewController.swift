//
//  EditMovoCashAlertsViewController.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

class EditMovoCashAlertUpdateAlertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func configureCell(title:String?, description: String?) {
        headerLbl.text = title
        descriptionLbl.text = description
    }
    
}

class EditMovoCashAlertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var operatorView: UIView!
    @IBOutlet weak var thresholdAmountView: UIView!
    
    
    @IBOutlet weak var operatorButton: UIButton!
    @IBOutlet weak var transferAmountField: UITextField!
    @IBOutlet weak var transferAmountLbl: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var smsField: UITextField!
    @IBOutlet weak var emailSwitch: HooleyCashAlertSwitchView!
    @IBOutlet weak var smsSwitch: HooleyCashAlertSwitchView!
    @IBOutlet weak var mobilePushSwitch: HooleyCashAlertSwitchView!
    @IBOutlet weak var alertSwitch: HooleyCashAlertSwitchView!

    var emailSwitchChanged:((Bool)->())?
    var smsSwitchChanged:((Bool)->())?
    var mobilePushSwitchChanged:((Bool)->())?
    var alertSwitchChanged:((Bool)->())?
    var operatorButtonTapped:(()->())?
    
    var amountTextChanged:((String)->())?
    var emailTextChanged:((String)->())?
    var mobileTextChanged:((String)->())?

    func configureCell(operatorType: CashAlertOperator, transferAmount: String, emailStr: String, smsStr: String, emailPrivacy: Bool, smsPrivacy: Bool, mobilePushPrivacy: Bool, alertPrivacy: Bool, isOperator: Bool) {
        
//        transferAmountLbl.text = "Threshold Amount"
        transferAmountField.font = Fonts.ALLER_REGULAR_12
        operatorView.isHidden = isOperator ? false : true
        thresholdAmountView.isHidden = isOperator ? false : true
//        transferAmountView.isHidden = isOperator ? false : true

        operatorButton.setTitle(operatorType == CashAlertOperator.greater ? "Greater than or equal" : "Less than or equal", for: .normal)
        transferAmountField.text = transferAmount
        emailField.text = emailStr
        smsField.text = smsStr
        
        emailSwitch.isSwitchOn = emailPrivacy
        smsSwitch.isSwitchOn = smsPrivacy
        mobilePushSwitch.isSwitchOn = mobilePushPrivacy

        emailSwitch.switchValueWasChanged = { value in
            self.emailSwitchChanged?(value)
        }
        smsSwitch.switchValueWasChanged = { value in
            self.smsSwitchChanged?(value)
        }
        mobilePushSwitch.switchValueWasChanged = { value in
            self.mobilePushSwitchChanged?(value)
        }
        alertSwitch.switchValueWasChanged = { value in
            self.alertSwitchChanged?(value)
        }
    }
    
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        if sender == transferAmountField {
            let str = sender.text ?? "0.0"
            amountTextChanged?(str)
        } else if sender == emailField {
            let str = sender.text ?? ""
            emailTextChanged?(str)
        } else if sender == smsField {
            let str = sender.text ?? "0"
            mobileTextChanged?(str)
        }
        
    }
    
    
    @IBAction func operatorButtonWasPressed(_ sender: UIButton) {
        operatorButtonTapped?()
    }
    
}

class EditMovoCashAlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var emailPrivacy = false
    private var smsPrivacy = false
    private var mobilePushAlertsPrivacy = false
    private var alertPrivacy = false
    private var emailStr = ""
    private var sms = ""
    private var amount = ""
    private var operatorType : CashAlertOperator = .less
    
    var customModel : CustomCashAlertModel?

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        populateData()
    }
    
    //MARK:- Helper Methods
    private func setupView() {
        let tableHeaderView = EditMovoCashAlertsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableHeaderView.configureView()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
        titlelbl.setAttributedTextWithSubscripts(str: "MOVO Cash^{®} Alerts")
        
        tableView.register(UINib(nibName: EditMovoCashAlertsSmsChargesTableViewCell.className, bundle: nil), forCellReuseIdentifier: EditMovoCashAlertsSmsChargesTableViewCell.className)
    }
    
    private func populateData() {
        if let model = customModel {
            if let alertModel = model.model {
                operatorType = alertModel.operatorTypeID == CashAlertOperator.greater.rawValue ? CashAlertOperator.greater : CashAlertOperator.less
                
                let amountValue = alertModel.amount ?? 0.0
                if amountValue == 0.0 {
                    amount = ""
                } else {
                    amount = String(amountValue)
                }
                emailStr = alertModel.email ?? ""
                emailPrivacy = emailStr.isEmpty ? false : true
                sms = alertModel.sms ?? ""
                smsPrivacy = sms.isEmpty ? false : true
                mobilePushAlertsPrivacy = alertModel.mobilePush ?? false
            }
            
        }
        tableView.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonWasPressed(_ sender: Any) {
        
        let isOperator = customModel?.isOperator ?? false
        if isOperator {
            if amount.isEmpty || amount == "0.0" {
                self.alertMessage(title: K.ALERT, alertMessage: "Please enter transfer amount", action: nil)
                return
            }
        }
        
        if emailPrivacy == true && emailStr.isEmpty {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter email", action: nil)
            return
        }
        
        if smsPrivacy == true && sms.isEmpty {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter mobile number", action: nil)
            return
        }
        
        if isOperator == false && smsPrivacy == false && emailPrivacy == false && mobilePushAlertsPrivacy == false {
            self.alertMessage(title: K.ALERT, alertMessage: "Please add atleast 1 information", action: nil)
            return
        }
        
        let requestModel = AlertModel(alertID: customModel?.model?.alertID, alertTypeID: customModel?.model?.alertTypeID, id: customModel?.model?.id, operatorTypeID: isOperator ? operatorType.rawValue : 0, amount: isOperator ? Double(amount) : 0.0, sms: smsPrivacy ? sms : "", email: emailPrivacy ? emailStr : "", mobilePush: mobilePushAlertsPrivacy)
        
        showProgressHud()
        HooleyPostAPIGeneric<AlertModel, BoolResponseModel>.postRequest(apiURL: API.Account.addupdateuseralerts, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: .REFRESH_CASH_ALERTS_SCREEN, object: nil)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    //MARK:- UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditMovoCashAlertUpdateAlertTableViewCell.className, for: indexPath) as! EditMovoCashAlertUpdateAlertTableViewCell
            cell.configureCell(title: customModel?.title, description: customModel?.decsription)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditMovoCashAlertTableViewCell.className, for: indexPath) as! EditMovoCashAlertTableViewCell
            
            cell.configureCell(operatorType: operatorType, transferAmount: amount, emailStr: emailStr, smsStr: sms, emailPrivacy: emailPrivacy, smsPrivacy: smsPrivacy, mobilePushPrivacy: mobilePushAlertsPrivacy, alertPrivacy: alertPrivacy, isOperator: customModel?.isOperator ?? false)
            
            cell.operatorButtonTapped = {
                let array = ["Greater than of equal", "Less than of equal"]
                Router.shared.openDataPickerPopUpVC(content: array, title: "Select operator", selectedValue: array[0], controller: self) { (index, result) in
                    self.operatorType = index == 0 ? .greater : .less
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            cell.amountTextChanged = { str in
                self.amount = str
            }
            
            cell.emailSwitchChanged = { value in
                self.emailPrivacy = value
            }
            cell.emailTextChanged = { str in
                self.emailStr = str
            }
            
            cell.smsSwitchChanged = { value in
                self.smsPrivacy = value
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            cell.mobileTextChanged = { str in
                self.sms = str
            }
            
            cell.mobilePushSwitchChanged = { value in
                self.mobilePushAlertsPrivacy = value
            }
            
            cell.alertSwitchChanged = { value in
                self.alertPrivacy = value
            }
            
            
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditMovoCashAlertsSmsChargesTableViewCell.className, for: indexPath) as! EditMovoCashAlertsSmsChargesTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default:
            return smsPrivacy ? 100 : 0
        }
    }

}
