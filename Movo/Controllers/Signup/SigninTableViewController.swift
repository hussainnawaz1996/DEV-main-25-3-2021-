//
//  SigninTableViewController.swift
//  Movo
//
//  Created by Ahmad on 14/11/2020.
//

import UIKit
import AuthenticationServices
import LocalAuthentication

class SigninTableViewController: UITableViewController {

    @IBOutlet weak var emailField: WhiteBorderedTextfield!
    @IBOutlet weak var passwordField: WhiteBorderedTextfield!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var touchIdView: UIStackView!
    @IBOutlet weak var touchIdIcon: UIImageView!
    
    private var userName = ""
    private var password = ""
    
    private var isRemembered = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        touchIdIcon.image = hasTopNotch ? Icons.FACE_ID_ICON : Icons.TOUCH_ID_ICON
//        touchIdView.isHidden = Common.devicePasscodeSet() ? false : true
        
        let rememberUserName = Common.getRememberedUserName()
        emailField.text = rememberUserName
        if let _ = rememberUserName {
            isRemembered = true
            setCheckBoxImage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.performProfiling()
        }
    }

    //MARK:- Helper Methods
    @IBAction func touchIdButtonWasPressed(_ sender: UIButton) {
        authenticateUser()
    }
    
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
                            self.userName = model.userName
                            self.password = model.password
                            if model.userName == "" {
                                Router.shared.openBiometricLoginTableViewController(controller: self)
                            } else {
                                self.loginUser(isBiometricLogin: true)
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
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 130
        case 2:
            return 150
        case 3:
//            return Common.devicePasscodeSet() ? 150 : 0
            return 150
        default:
            return 150
        }
    }

    @IBAction func signinButtonWasPressed(_ sender: BlackBGButton) {
        let name = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        if name.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter name", action: nil)
            return
        }
        
        if password.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter password", action: nil)
            return
        }
        
        self.userName = name
        self.password = password
        loginUser(isBiometricLogin: false)
    }
    
    private func loginUser(isBiometricLogin: Bool) {
        
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
                        self.rememberUserName()
                        ModelParser.parseLoginModel(model: responseModel.data, password: self.password)
                        ModeSelection.instance.loginMode()
                        UserDefaults.standard.setValue(isBiometricLogin, forKey: UserDefaultKeys.iSBiometricLogin)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonWasPressed(_ sender: UIButton) {
        Router.shared.openForgotPasswordUsernameViewController(controller: self)
    }
    
    @IBAction func rememberButtonWasPressed(_ sender: UIButton) {
        isRemembered = !isRemembered
        setCheckBoxImage()
        rememberUserName()
    }
    
    private func setCheckBoxImage() {
        let image = isRemembered ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED
        checkBoxButton.setImage(image, for: .normal)
    }
    
    private func rememberUserName() {
        let userName = emailField.text ?? ""

        if isRemembered {
            Common.saveRememberedUsername(name: userName)
        } else {
            Common.saveRememberedUsername(name: "")
        }
    }
}
