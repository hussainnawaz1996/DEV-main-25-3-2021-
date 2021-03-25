//
//  BiometricLoginTableViewController.swift
//  Movo
//
//  Created by Ahmad on 01/12/2020.
//

import UIKit

class BiometricLoginTableViewController: UITableViewController {
    
    @IBOutlet weak var touchIdIcon: UIImageView!
    @IBOutlet var userNameField: WhiteBorderedTextfield!
    @IBOutlet var passwordTextField: WhiteBorderedTextfield!
    
    private var userName = ""
    private var password = ""
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.backgroundView = UIImageView(image: UIImage(named: "bg_icon"))
        touchIdIcon.image = hasTopNotch ? Icons.FACE_ID_ICON : Icons.TOUCH_ID_ICON
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupView() -> Void {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        userNameField.textChanged = { value in
            self.userName = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        passwordTextField.textChanged = { value in
            self.password = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //MARK:- Helper Methods
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInButtonWasPressed(_ sender: Any) {
        
        view.endEditing(true)
        
        let name = userNameField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if name.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter name", action: nil)
            return
        }
        
        if password.isEmpty {
            alertMessage(title: K.ALERT, alertMessage: "please enter password", action: nil)
            return
        }

        let deviceToken : String = ""

//        if let str = UserDefaults.standard.string(forKey: K.KFCM_TOKEN){
//            deviceToken = str
//        }
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) as? String ?? ""
        let sessionIdResponse = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionIdResponse) as? String ?? ""
        let osVersionName = UIDevice.current.systemVersion
        let modelName = UIDevice.modelName
        
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
                        let model = BiometricLoginModel(userName: self.userName, password: self.password)
                        BiometricLoginInfoStruct.instance.saveData(model: model)
                        ModelParser.parseLoginModel(model: responseModel.data, password: self.password)
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
