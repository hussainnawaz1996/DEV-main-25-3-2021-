//
//  UpdateProfileCodeViewController.swift
//  Movo
//
//  Created by Ahmad on 29/01/2021.
//

import UIKit

protocol UpdateProfileCodeViewControllerDelegate: class {
    func profileUpdated()
}

class UpdateProfileCodeViewController: UIViewController {

    @IBOutlet weak var codeField: CustomTextField!
    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    weak var delegate: UpdateProfileCodeViewControllerDelegate?
    
    private var seconds = 60
    private var timer = Timer()
    private var isTimerRunning = false
    
    var updateProfileRequestModel : UpdateProfileRequestModel?
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 12.0, *) {
            codeField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        startTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
        
    //MARK:- IBActions
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonWasPressed(_ sender: BlackBGButton) {
        let codeStr = codeField.text ?? ""
        
        if codeStr.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter code", action: {})
            return
        }
      
        isCodeVerifiedAPICall(code: codeStr)
    }
    
    @IBAction func resendCodeButtonWasPressed(_ sender: UIButton) {
        sendVerificationCodeAPICall()
    }
}


extension UpdateProfileCodeViewController {
    private func sendVerificationCodeAPICall() {
        let requestModel = SendVerificationCodeRequestModel()
        
        showProgressHud()
        HooleyPostAPIGeneric<SendVerificationCodeRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.sendverificationcode, requestModel: requestModel) { [weak self] (result) in
            guard let `self` = self else { return }
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
        
    private func isCodeVerifiedAPICall(code:String) {
        let requestModel = IsCodeVerifyRequestModel(code: code)
        
        showProgressHud()
        HooleyPostAPIGeneric<IsCodeVerifyRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.iscodeverified, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.updateProfileAPICall()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func updateProfileAPICall() {
        
        if let requestModel = updateProfileRequestModel {
            showProgressHud()
            HooleyPostAPIGeneric<UpdateProfileRequestModel, UpdateProfileResponseModel>.postRequest(apiURL: API.Account.updateprofile, requestModel: requestModel) { [weak self] (result) in
                guard let `self`  = self else { return }
                DispatchQueue.main.async {
                    self.hideProgressHud()
                    switch result {
                    case .success(let responseModel):
                        
                        if responseModel.isError{
                            self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                            self.delegate?.profileUpdated()
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

extension UpdateProfileCodeViewController {
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
