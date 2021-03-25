//
//  ChangePasswordView.swift
//  Movo
//
//  Created by Ahmad on 04/12/2020.
//

import UIKit

class ChangePasswordTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    @IBOutlet weak var limitationView: UIView!
    @IBOutlet var upperCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var lowerCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var numberCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var specialCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var eightPlusCaseLabels: [ValidPasswordLabel]!
    
    var infoButtonClicked:(()->())?
    var passwordChanged:((String)->())?
    var newPasswordChanged:((String)->())?
    var confirmNewPasswordChanged:((String)->())?
    
    func configureCell(oldPassword: String, newPassword: String, confirmNewPassword: String) {
        
        limitationView.roundedUIView(withRadius: 4.0)

        oldPasswordField.text = oldPassword
        newPasswordField.text = newPassword
        confirmNewPasswordField.text = confirmNewPassword
        
        if oldPassword.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty {
            resetLabels()
        }
    }
    
    private func resetLabels() {
        upperCaseLabels.forEach { (label) in
            label.disable()
        }
        
        lowerCaseLabels.forEach { (label) in
            label.disable()
        }
        
        numberCaseLabels.forEach { (label) in
            label.disable()
        }
        
        specialCaseLabels.forEach { (label) in
            label.disable()
        }
        
        eightPlusCaseLabels.forEach { (label) in
            label.disable()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        infoButtonClicked?()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let str = sender.text ?? ""
        if sender == oldPasswordField {
            passwordChanged?(str)
        } else if sender == newPasswordField {
            checkValidPassword(str: str)
            newPasswordChanged?(str)
        } else if sender == confirmNewPasswordField {
            confirmNewPasswordChanged?(str)
        }
    }
    
    private func checkValidPassword(str: String) {
        upperCaseLabels.forEach { (label) in
            if str.checkCapital() {
                label.enable()
            } else {
                label.disable()
            }
        }
        
        lowerCaseLabels.forEach { (label) in
            if str.checkLowerCased() {
                label.enable()
            } else {
                label.disable()
            }
        }
        
        numberCaseLabels.forEach { (label) in
            if str.checkNumber() {
                label.enable()
            } else {
                label.disable()
            }
        }
        
        specialCaseLabels.forEach { (label) in
            if str.checkSpecialCharacters() {
                label.enable()
            } else {
                label.disable()
            }
        }
        
        eightPlusCaseLabels.forEach { (label) in
            if str.check8Plus() {
                label.enable()
            } else {
                label.disable()
            }
        }
    }
    
}

class ChangePasswordView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    
    private var oldPassword = ""
    private var newPassword = ""
    private var confirmNewPassword = ""
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.tableFooterView = UIView()
    }
    
    func setup() {
        
    }
    
    func changeButtonWasPressed() {
        let savePassword = Common.getUserPassword() ?? ""
        
        if oldPassword.isEmpty {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please enter your current password", action: nil)
            return
        }
        
        if newPassword.isEmpty {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please enter your new password", action: nil)
            return
        }
        
        if confirmNewPassword.isEmpty {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please confirm your password", action: nil)
            return
        }
        
        if savePassword != oldPassword {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "your current password is wrong", action: nil)
            return
        }
        
        if newPassword != confirmNewPassword {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "your passswords mismatched", action: nil)
            return
        }
        
        if newPassword.checkCapital() && newPassword.checkLowerCased() && newPassword.checkNumber() && newPassword.checkSpecialCharacters() && newPassword.check8Plus() {
            updatePasswordAPICall()
        } else {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Your password does not fulfil the requirements", action: nil)
            return
        }
    }
    
    //MARK:- UITableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChangePasswordTableViewCell.className, for: indexPath) as! ChangePasswordTableViewCell
        
        cell.configureCell(oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword)
        cell.passwordChanged = { str in
            self.oldPassword = str
        }
        
        cell.newPasswordChanged = { str in
            self.newPassword = str
        }
        
        cell.confirmNewPasswordChanged = { str in
            self.confirmNewPassword = str
        }
        
        cell.infoButtonClicked  = {
            let str = "Password should be at least 8 characters and include: \n A uppercase letter (A-Z) \n A lower letter (a-z) \n A number \n A special character"
            self.controller!.alertMessage(title: "Password Guidelines", alertMessage: str, action: nil)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

extension ChangePasswordView {
    
    private func updatePasswordAPICall() {
        let requestModel = UpdatePasswordRequestModel(oldPassword: oldPassword, newPassword: newPassword)
        
        showProgressOnView()
        HooleyPostAPIGeneric<UpdatePasswordRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.updatepassword, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.controller!.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    } else {
                        Common.saveUserPassword(str: self.newPassword)

                        if let model = BiometricLoginInfoStruct.instance.fetchData() {
                            let biometricUsername = model.userName
                            if let profile = ProfileDetails.instance.getProfileDetails(){
                                if biometricUsername == profile.userName {
                                    let updatedModel = BiometricLoginModel(userName: biometricUsername, password: self.newPassword)
                                    BiometricLoginInfoStruct.instance.saveData(model: updatedModel)
                                }
                            }
                        }
                        
                        self.oldPassword = ""
                        self.newPassword = ""
                        self.confirmNewPassword = ""
                        self.tableView.reloadData()
                        
                        self.controller!.alertMessage(title: K.SUCCESS, alertMessage: "Password updated successfully", action: nil)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
