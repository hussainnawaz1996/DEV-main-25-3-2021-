//
//  NewCredentialsViewController.swift
//  Movo
//
//  Created by Ahmad on 28/12/2020.
//

import UIKit

class NewCredentialsViewController: UIViewController {

    @IBOutlet weak var codeField: WhiteBorderedTextfield!
    @IBOutlet weak var passwordField: WhiteBorderedTextfield!
    @IBOutlet weak var confirmPasswordField: WhiteBorderedTextfield!
    
    @IBOutlet var upperCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var lowerCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var numberCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var specialCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var eightPlusCaseLabels: [ValidPasswordLabel]!
    @IBOutlet weak var limitView: UIView!

    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    
    private var isValidPassword = false
    private var seconds = 60
    private var timer = Timer()
    private var isTimerRunning = false
    
    var username: String?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startTimer()
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
    
    //MARK:- Helper Methods
    private func setupView() {
        passwordField.rightImage = Icons.EYE_ICON
        confirmPasswordField.rightImage = Icons.EYE_ICON

        if #available(iOS 12.0, *) {
            codeField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        
        passwordField.rightButtonPressed = {
            self.passwordField.isSecureTextEntry = !self.passwordField.isSecureTextEntry
        }
        confirmPasswordField.rightButtonPressed = {
            self.confirmPasswordField.isSecureTextEntry = !self.confirmPasswordField.isSecureTextEntry
        }
        
        limitView.backgroundColor = Colors.LIGHT_GREY
        limitView.roundedUIView(withRadius: 4.0)

    }
    
    //MARK:- IBActions
    @IBAction func passwordFieldChanged(_ sender: UITextField) {
        let str = sender.text ?? ""
        
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
        
        if str.checkCapital() && str.checkLowerCased() && str.checkNumber() && str.checkSpecialCharacters() && str.check8Plus() {
            self.isValidPassword = true
        } else {
            self.isValidPassword = false
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonWasPressed(_ sender: BlackBGButton) {
        let codeStr = codeField.text ?? ""
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        
        if codeStr.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter code", action: {})
            return
        }
        if password.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter password", action: {})
            return
        }
        
        if isValidPassword == false {
            alertMessage(title: K.ALERT, alertMessage: "Please enter valid password", action: {})
            return
        }
        if confirmPassword.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter confirm password", action: {})
            return
        }
        if password != confirmPassword {
            alertMessage(title: K.ALERT, alertMessage: "passwords don't match", action: {})
            return
        }
        
        changePasswordAPICall(code: codeStr, password: password)
    }
    
    @IBAction func resendCodeButtonWasPressed(_ sender: UIButton) {
        resendAPICall()
    }
}


extension NewCredentialsViewController {
    private func resendAPICall() {
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
                        self.startTimer()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func changePasswordAPICall(code:String, password: String) {
        let requestModel = ChangeForgotPasswordWithCodeRequestModel(username: username, phoneNumber: "", newPassword: password, code: code)
        
        showProgressHud()
        HooleyPostAPIGeneric<ChangeForgotPasswordWithCodeRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.changeforgotpasswordwithcode, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.alertMessage(title: K.SUCCESS, alertMessage: "Password Changed Successfully", action: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}

extension NewCredentialsViewController {
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            resetTimer()
            timerLbl.text = "00:00"
            timerLbl.isHidden = true
            resendCodeButton.isHidden = false
            //Send alert to indicate "time's up!"
        } else {
            timerLbl.isHidden = false
            seconds -= 1
            timerLbl.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    private func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    
    private func resetTimer() {
        timer.invalidate()
        seconds = 60
        timerLbl.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        
    }
    private func startTimer() {
        if isTimerRunning == false {
            resendCodeButton.isHidden = true
            runTimer()
        }
    }
}
