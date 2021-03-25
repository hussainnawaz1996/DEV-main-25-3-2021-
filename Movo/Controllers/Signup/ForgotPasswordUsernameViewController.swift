//
//  ForgotPasswordUsernameViewController.swift
//  Movo
//
//  Created by Ahmad on 28/12/2020.
//

import UIKit

class ForgotPasswordUsernameViewController: UIViewController {

    @IBOutlet weak var usernameField: WhiteBorderedTextfield!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.leftImage = Icons.EMAIL_ICON
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
//    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: BlackBGButton) {
        
        let username = usernameField.text ?? ""
        if username.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "Please enter username", action: {})
            return
        }
        
        let requestModel = ForgotSentVerificationCodeRequestModel(username: username, countryCode: "", phoneNumber: "")
        
        showProgressHud()
        HooleyPostAPIGeneric<ForgotSentVerificationCodeRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.forgotsentverificationcode, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        Router.shared.openNewCredentialsViewController(username: username, controller: self)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
}
