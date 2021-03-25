//
//  AddPayeeViewController.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class AddPayeeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var payeeNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var depositAccountNumberField: UITextField!
    @IBOutlet weak var confirmAccountNumberField: UITextField!
    
    var pickerButtonTapped:(()->())?
    var textChanged:((Int, String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(requestModel : AddPayeeRequestModel?, customModel: CustomAddPayeeModel?, selectedState : StateModel?) {
        
        selectionStyle = .none
        if let model = requestModel {
            payeeNameField.text = model.payeeName
            addressField.text = model.address
            cityField.text = model.city
            zipCodeField.text = model.zip
            nickNameField.text = model.nickName
            depositAccountNumberField.text = model.depositAccountNumber
            confirmAccountNumberField.text = model.depositAccountNumber
        }
        
        if let model = customModel {
            payeeNameField.text = model.payeeName
            addressField.text = model.payeeAddress
        }
        stateField.text = selectedState?.name
    }
    
    @IBAction func pickerButtonWasPressed(_ sender: UIButton) {
        pickerButtonTapped?()
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let str = sender.text ?? ""
        if sender == payeeNameField {
            textChanged?(1,str)
        } else if sender == addressField {
            textChanged?(2,str)
        } else if sender == cityField {
            textChanged?(3,str)
        } else if sender == zipCodeField {
            textChanged?(5, str)
        } else if sender == nickNameField {
            textChanged?(6, str)
        } else if sender == depositAccountNumberField {
            textChanged?(7, str)
        } else if sender == confirmAccountNumberField {
            textChanged?(8, str)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        if textField == depositAccountNumberField || textField == confirmAccountNumberField {
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
}


class AddPayeeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var payeeName = ""
    private var address = ""
    private var city = ""
    private var zipcode = ""
    private var nickName = ""
    private var accountNumber = ""
    private var confirmAccountNumber = ""
    private var isSearchFlow = false
    
    private var statesArray = [StateModel]()
    private var selectedState : StateModel?
    
    var requestModel : AddPayeeRequestModel?
    var customModel: CustomAddPayeeModel?

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = requestModel {
            payeeName = model.payeeName ?? ""
            address = model.address ?? ""
            city = model.city ?? ""
            zipcode = model.zip ?? ""
            nickName = model.nickName ?? ""
            accountNumber = model.depositAccountNumber ?? ""
            confirmAccountNumber = model.depositAccountNumber ?? ""
            
        }
        
        if let model = customModel {
            payeeName = model.payeeName ?? ""
            address = model.payeeAddress ?? ""
            isSearchFlow = model.isSearchFlow
            selectedState = model.selectedState
        }
        
        getStates()
        tableView.tableFooterView = UIView()
    }

    //MARK:- IBActions
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        let result = validation()
        if result.status {
            
            if requestModel == nil {
                //it means, add payee add flow
                var requestmodel : AddPayeeRequestModel?
                if isSearchFlow {
                    requestmodel = AddPayeeRequestModel(srNo: customModel?.payeeSerioulNumber ?? "", payeeName: payeeName, address: address, city: city, stateID: selectedState?.id, stateIso2: selectedState?.iso2, zip: zipcode, nickName: nickName, depositAccountNumber: accountNumber)
                } else {
                    requestmodel = AddPayeeRequestModel(srNo: "", payeeName: payeeName, address: address, city: city, stateID: selectedState?.id, stateIso2: selectedState?.iso2, zip: zipcode, nickName: nickName, depositAccountNumber: accountNumber)
                }
                Router.shared.openPayeeReceiptViewController(requestModel: requestmodel!, selectedState: selectedState, isSearchFlow: isSearchFlow, controller: self)
            } else {
                //it means, my payee, edit flow
                let requestmodel = AddPayeeRequestModel(srNo: requestModel?.srNo, payeeName: payeeName, address: address, city: city, stateID: selectedState?.id, stateIso2: selectedState?.iso2, zip: zipcode, nickName: nickName, depositAccountNumber: accountNumber)
                
                
                showProgressHud()
                HooleyPostAPIGeneric<AddPayeeRequestModel, AddPayeeResponseModel>.postRequest(apiURL: API.ECheckbook.editcardholderpayee, requestModel: requestmodel) { [weak self] (result) in
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
                                    NotificationCenter.default.post(name: .REFRESH_MY_PAYEES_SCREEN, object: nil)
                                }
                            }
                            
                        case .failure(let error):
                            let err = CustomError(description: (error as? CustomError)?.description ?? "")
                            self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                        }
                    }
                }
            }
        } else {
            alertMessage(title: K.ALERT, alertMessage: result.msg, action: nil)
        }
    }
    
    private func validation() -> (msg: String, status: Bool) {
        
        if payeeName.isEmpty {
            return ("payee name is missing", false)
        }
        
        if address.isEmpty {
            return ("email address is missing", false)
        }
        
        if city.isEmpty {
            return ("city is missing", false)
        }
        
        if selectedState == nil {
            return ("state is missing", false)
        }
        
        if zipcode.isEmpty {
            return ("zip code is missing", false)
        }
        
        if nickName.isEmpty {
            return ("nick name is missing", false)
        }
        
        if accountNumber.isEmpty {
            return ("account number is missing", false)
        }
        
        if confirmAccountNumber.isEmpty {
            return ("confirm account number is missing", false)
        }
        
        if accountNumber != confirmAccountNumber {
            return ("account numbers don't match", false)
        }
        
        return ("", true)
    }
    
}

extension AddPayeeViewController : UITableViewDelegate, UITableViewDataSource {
    //MARK:- UITablView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddPayeeTableViewCell.className, for: indexPath) as! AddPayeeTableViewCell
        
        cell.configureCell(requestModel: requestModel, customModel: customModel, selectedState: selectedState)
        cell.pickerButtonTapped = {
            if self.statesArray.isEmpty {
                return
            }
            
            var strArray = [String]()
            self.statesArray.forEach { (model) in
                strArray.append(model.name ?? "")
            }
            
            if strArray.isEmpty {
                self.alertMessage(title: K.ALERT, alertMessage: "No state found", action: {})
                return
            }
            
            Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select State", selectedValue: strArray[0], controller: self, dataPickedHandler: { (index, value) in
                if let index = self.statesArray.lastIndex(where: {$0.name == value}) {
                    self.selectedState = self.statesArray[index]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        cell.textChanged = { index, value in
            switch index {
            case 1:
                self.payeeName = value
            case 2:
                self.address = value
            case 3:
                self.city = value
            case 5:
                self.zipcode = value
            case 6:
                self.nickName = value
            case 7:
                self.accountNumber = value
            case 8:
                self.confirmAccountNumber = value
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
}


extension AddPayeeViewController {
    
    private func getStates() -> Void {
        
        showProgressHud()
        
        let url = API.Common.getstates + "/\(UnitedStatesId)"
        HooleyAPIGeneric<GetStatesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.statesArray = responseModel.data ?? []
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
}
