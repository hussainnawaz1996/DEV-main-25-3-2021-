//
//  CashCardEditNameViewController.swift
//  Movo
//
//  Created by Ahmad on 09/01/2021.
//

import UIKit

class CashCardEditNameViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    var selectedCard : CardModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonWasPresed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonWasPressed(_ sender: UIButton) {
        
        let name = nameField.text ?? ""
        
        if name.isEmpty {
            self.alertMessage(title: K.ALERT, alertMessage: "Please enter name", action: nil)
        } else {
            
            let requestModel = UpdateCashCardNameRequestModel(referenceID: selectedCard?.referenceID ?? "", nameOnCard: name)
            
            showProgressHud()
            HooleyPostAPIGeneric<UpdateCashCardNameRequestModel, BoolResponseModel>.postRequest(apiURL: API.Card.updatename, requestModel: requestModel) { [weak self] (result) in
                guard let `self`  = self else { return }
                DispatchQueue.main.async {
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):
                        
                        if responseModel.isError{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.alertMessage(title: K.SUCCESS, alertMessage: "Updated Successfully") {
                                self.navigationController?.popViewController(animated: true)
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
