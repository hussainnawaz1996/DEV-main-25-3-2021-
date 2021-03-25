//
//  PayeeReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 09/12/2020.
//

import UIKit

class PayeeReceiptViewController: UIViewController {
    
    @IBOutlet weak var payeeNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var deleteButton: RedBGButton!
    var requestModel : AddPayeeRequestModel?
    var selectedState : StateModel?
    var isSearchFlow = false
    
    private var isEditFlow = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = requestModel {
            payeeNameLbl.text = model.payeeName
            addressLbl.text = model.address
            cityLbl.text = model.city
            zipCodeLbl.text = model.zip
            nickNameLbl.text = model.nickName
            accountNumberLbl.text = model.depositAccountNumber
            
            if isSearchFlow {
                isEditFlow = false
            } else {
                isEditFlow = (model.srNo?.isEmpty ?? false) ? false : true
            }
            
        }
        
        stateLbl.text = selectedState?.name
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
    
    @IBAction func deleteButtonWasPressed(_ sender: RedBGButton) {
        showProgressHud()
        let url = API.ECheckbook.deletecardholderpayee + "/\(requestModel?.srNo ?? "")" + "/\(requestModel?.depositAccountNumber ?? "")"
        HooleyAPIGeneric<AddPayeeResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
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
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        
        if isEditFlow {
            let customModel = CustomAddPayeeModel(selectedState: selectedState, payeeName: requestModel?.payeeName, payeeSerioulNumber: nil, payeeAddress: requestModel?.address, isSearchFlow: false)
            Router.shared.openAddPayeeViewController(requestModel: requestModel, customModel: customModel, controller: self)
        } else {
            
            if let model = requestModel {
                
                showProgressHud()
                HooleyPostAPIGeneric<AddPayeeRequestModel, AddPayeeResponseModel>.postRequest(apiURL: API.ECheckbook.addpayee, requestModel: model) { [weak self] (result) in
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
    
}
