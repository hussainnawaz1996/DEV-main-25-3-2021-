//
//  SigninSplashViewController.swift
//  Movo
//
//  Created by Ahmad on 02/01/2021.
//

import UIKit
import LocalAuthentication

class SigninSplashViewController: UIViewController {

    @IBOutlet weak var touchIdIcon: UIImageView!

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        callLogoutAPI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        touchIdIcon.image = hasTopNotch ? Icons.FACE_ID_ICON : Icons.TOUCH_ID_ICON
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- IBActions
    @IBAction func touchIdButtonWasPressed(_ sender: UIButton) {
        authenticateUser()
    }
    
    @IBAction func signinButtonWasPressed(_ sender: BlackBGButton) {
        Router.shared.openSigninTableViewController(controller: self)
    }
    
    @IBAction func getEnrolledButtonWasPressed(_ sender: UIButton) {
        Router.shared.openPersonalDetailViewController(controller: self)
    }
    
    //MARK: - Helper Methods
    private func callLogoutAPI() {
        
        var token = ""
        if let profile = ProfileDetails.instance.getProfileDetails(){
            token = profile.accessToken
        }
        
        if token != "" {
            logoutAPICall()
        }
    }
    
    private func logoutAPICall() {
        showProgressHud()
        let url = API.Account.logout + "/true"
        HooleyAPIGeneric<BoolResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    } else {
                        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isUserLogin)
                        ProfileDetails.instance.removeProfileOnLogout()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }

}


extension SigninSplashViewController {
    
    func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        if let model = BiometricLoginInfoStruct.instance.fetchData() {
                            let userName = model.userName
                            let password = model.password
                            if model.userName == "" {
                                Router.shared.openBiometricLoginTableViewController(controller: self)
                            } else {
                                self.loginUser(userName: userName, password: password)
                            }
                        } else {
                            Router.shared.openBiometricLoginTableViewController(controller: self)
                        }
                    } else {
                        self.alertMessage(title: "Authentication failed", alertMessage: "Sorry!", action: nil)
                    }
                }
            }
        } else {
            self.alertMessage(title: "Touch/Face ID not available", alertMessage:  "Go to 'Settings -> Touch/Face ID & Passcode' and register at least one passcode", action: nil)
        }
    }
    
    
    private func loginUser(userName:String, password: String) {
        
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) as? String ?? ""
        let sessionIdResponse = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionIdResponse) as? String ?? ""

        let osVersionName = UIDevice.current.systemVersion
        let modelName = UIDevice.modelName
        let deviceToken : String = ""

//        if let str = UserDefaults.standard.string(forKey: K.KFCM_TOKEN){
//            deviceToken = str
//        }
        
        let requestModel =  SigninRequestModel(username: userName, password: password, sessionID: sessionId, lnSessionIDResponse: sessionIdResponse, deviceToken: deviceToken, deviceModel: modelName, os: OSType.iOS.rawValue, version: osVersionName, deviceType: DeviceType.iOS.rawValue)
        
        showProgressHud()
        HooleyPostAPIGeneric<SigninRequestModel, SigninResponseModel>.postRequest(apiURL: API.Account.login, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages, action: nil)
                    }else{
                        ModelParser.parseLoginModel(model: responseModel.data, password: password)
                        ModeSelection.instance.loginMode()
                        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.iSBiometricLogin)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
