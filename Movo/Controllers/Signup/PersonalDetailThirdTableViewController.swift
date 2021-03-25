//
//  PersonalDetailThirdTableViewController.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit

protocol PersonalDetailThirdTableViewControllerDelegate : class {
    func thirdScreenDismiss(model: CustomSignupModel?)
}

class PersonalDetailThirdTableViewController: UITableViewController {
    @IBOutlet var topButtons: [CircularSelectionButton]!
    @IBOutlet weak var usernameActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameAvailableLbl: UILabel!
    
    @IBOutlet weak var userNameField: WhiteBorderedTextfield!
    @IBOutlet weak var passwordField: WhiteBorderedTextfield!
    @IBOutlet weak var secretQuestionField: WhiteBorderedTextfield!
    @IBOutlet weak var secretQuestionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var limitationView: UIView!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var answerField: WhiteBorderedTextfield!
    
    @IBOutlet var upperCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var lowerCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var numberCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var specialCaseLabels: [ValidPasswordLabel]!
    @IBOutlet var eightPlusCaseLabels: [ValidPasswordLabel]!
    @IBOutlet weak var verificationCodeLabel: UILabel!
    
    @IBOutlet weak var otpField1: UITextField!
    @IBOutlet weak var otpField2: UITextField!
    @IBOutlet weak var otpField3: UITextField!
    @IBOutlet weak var otpField4: UITextField!
    @IBOutlet weak var otpField5: UITextField!
    @IBOutlet weak var otpField6: UITextField!
    
    private var currentTextField: UITextField!

    var customSignupModel:CustomSignupModel?
    weak var delegate : PersonalDetailThirdTableViewControllerDelegate?
    
    private var isRememberButtonTapped = false
    private var userName = ""
    private var password = ""
    private var isValidPassword = false
    private var secretQuestionsList = [NameIdModel]()
    private var selectedSecretQuestion : NameIdModel?
    private var conversationId = ""
    private var answer = ""
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromModel()
        
        getSecretQuestions()
        createOTPAPICall(isResend: false)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.usernameAvailableLbl.isHidden = true
        self.usernameActivityIndicator.isHidden = true
        
        topButtons.forEach { (button) in
            if button.tag == 2 {
                button.enable()
            } else {
                button.disable()
            }
        }
    }
    
    //MARK:- Helper Methods
    private func updateDataFromModel() {
        if let model = customSignupModel {
            self.userName = model.user3rdScreenModel?.userName ?? ""
            self.password = model.user3rdScreenModel?.password ?? ""
            self.isRememberButtonTapped = model.user3rdScreenModel?.isRememberMe ?? false
            self.selectedSecretQuestion = model.user3rdScreenModel?.selectedSecretQuestion
            self.answer = model.user3rdScreenModel?.answer ?? ""
            
            self.userNameField.text = self.userName
            self.passwordField.text = self.password
            self.makePasswordValidityCheck(str: self.password)
            let img = isRememberButtonTapped ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED
            rememberMeButton.setImage(img, for: .normal)
            self.secretQuestionField.text = self.selectedSecretQuestion?.name
            self.answerField.text = self.answer
        }
    }
    
    private func syncData() {
        customSignupModel?.user3rdScreenModel?.userName = userName
        customSignupModel?.user3rdScreenModel?.password = password
        customSignupModel?.user3rdScreenModel?.isRememberMe = isRememberButtonTapped
        customSignupModel?.user3rdScreenModel?.selectedSecretQuestion = selectedSecretQuestion
        customSignupModel?.user3rdScreenModel?.answer = answer
    }
    
    private func setupView() {
        
        userNameField.textChanged = { str in
            self.userName = str
        }
        
        passwordField.textChanged = { str in
            self.password = str
        }
        
        answerField.textChanged = { str in
            self.answer = str
        }
        
        limitationView.backgroundColor = Colors.LIGHT_GREY
        limitationView.roundedUIView(withRadius: 4.0)
        passwordField.rightImage = Icons.EYE_ICON
        secretQuestionField.rightImage = Icons.SIGNUP_ARROW_DOWN_ICON
        passwordField.rightButtonPressed = {
            self.passwordField.isSecureTextEntry = !self.passwordField.isSecureTextEntry
        }
        
        if let model = customSignupModel {
            verificationCodeLabel.text = "Please enter the OTP sent to \(model.phoneNumber)"
        }
        
        otpField1.delegate = self
        otpField2.delegate = self
        otpField3.delegate = self
        otpField4.delegate = self
        otpField5.delegate = self
        otpField6.delegate = self
        
        if #available(iOS 12.0, *) {
            otpField1.textContentType = .oneTimeCode
            otpField2.textContentType = .oneTimeCode
            otpField3.textContentType = .oneTimeCode
            otpField4.textContentType = .oneTimeCode
            otpField5.textContentType = .oneTimeCode
            otpField6.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        
        otpField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpField5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        otpField6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)

    }
    
    private func validation() -> (msg: String, status: Bool) {
        
        if userName == "" {
            return ("Please enter username", false)
        }
        
        if password == "" {
            return ("Please enter password", false)
        }
        
        if isValidPassword == false {
            return ("Please enter valid password", false)
        }
        
        if selectedSecretQuestion == nil {
            return ("Please select secret question", false)
        }
        
        if answer == "" {
            return ("Please enter answer", false)
        }
        
        let otp1 = otpField1.text ?? ""
        let otp2 = otpField2.text ?? ""
        let otp3 = otpField3.text ?? ""
        let otp4 = otpField4.text ?? ""
        let otp5 = otpField5.text ?? ""
        let otp6 = otpField6.text ?? ""
        
        if otp1.isEmpty || otp2.isEmpty || otp3.isEmpty || otp4.isEmpty || otp5.isEmpty || otp6.isEmpty {
            return ("Please enter complete code", false)
        }
        
        return("", true)
    }
    
    //MARK:- IBActions
    @IBAction func resendCodeButtonWasPressed(_ sender: UIButton) {
        createOTPAPICall(isResend: true)
    }
    
    @IBAction func userNameFieldChanged(_ sender: UITextField) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(isUserNameExistsAPICall), object: nil)
//        self.perform(#selector(isUserNameExistsAPICall), with: nil, afterDelay: 1.0)
    }
    
    @IBAction func passwordFieldChanged(_ sender: UITextField) {
        let str = sender.text ?? ""
        makePasswordValidityCheck(str: str)
    }
    
    private func makePasswordValidityCheck(str: String) {
        
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
    
    @IBAction func secretQuestionButtonWasPressed(_ sender: UIButton) {
        if secretQuestionsList.isEmpty {
            return
        }
        
        var strArray = [String]()
        secretQuestionsList.forEach { (model) in
            strArray.append(model.name ?? "")
        }
        
        Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Question", selectedValue: strArray[0], controller: self, dataPickedHandler: { (index, value) in
            if let index = self.secretQuestionsList.lastIndex(where: {$0.name == value}) {
                self.selectedSecretQuestion = self.secretQuestionsList[index]
                self.secretQuestionField.text = self.selectedSecretQuestion?.name
            }
        })
    }
    
    @IBAction func rememerButtonPressed(_ sender: UIButton) {
        isRememberButtonTapped = !isRememberButtonTapped
        let img = isRememberButtonTapped ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED
        rememberMeButton.setImage(img, for: .normal)
    }
    
    @IBAction func topButtonWasPressed(_ sender: CircularSelectionButton) {
        topButtons.forEach { (button) in
            button.disable()
            if sender.tag == button.tag {
                sender.enable()
            }
        }
        
        if sender.tag == 0 {
            if let navController = self.navigationController {
                for controller in navController.viewControllers as Array {
                    if controller.isKind(of: PersonalDetailTableViewController.self) {
                        navController.popToViewController(controller, animated: false)
                        break
                    }
                }
            }
        } else if sender.tag == 1 {
            navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func submitButtonWasPressed(_ sender: BlackBGButton) {
        let result = validation()
        if result.status {
            verifyOTPAPICall()
        } else {
            alertMessage(title: K.ALERT, alertMessage: result.msg, action: nil)
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        syncData()
        navigationController?.popViewController(animated: true)
        delegate?.thirdScreenDismiss(model: customSignupModel)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.usernameAvailableLbl.isHidden ? UITableView.automaticDimension : 70
        default:
            return UITableView.automaticDimension
        }
    }
    
}


extension PersonalDetailThirdTableViewController {
    private func setupUsernameField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.usernameActivityIndicator.isHidden = isLoading ? false : true
            if isLoading {
                self.usernameActivityIndicator.startAnimating()
            } else {
                self.usernameActivityIndicator.stopAnimating()
            }
        }
    }
    
    //MARK:- API Calls
    @objc private func isUserNameExistsAPICall() {
        let username = userNameField.text ?? ""
        if username.isEmpty {
            self.usernameAvailableLbl.isHidden = true
            tableView.reloadData()
            return
        }
        
        self.usernameAvailableLbl.isHidden = false
        self.usernameAvailableLbl.textColor = Colors.BLACK
        self.usernameAvailableLbl.text = "Checking..."
        self.setupUsernameField(isLoading: true)
        tableView.reloadData()
        
        let url = API.Account.isUsernameExists + "/\(username)"
        HooleyAPIGeneric<BoolResponseModel>.fetchRequest(apiURL: url) { (result) in
            switch result {
            case .success(let responseModel):
                DispatchQueue.main.async {
                    self.setupUsernameField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        if responseModel.data ?? false {
                            self.usernameAvailableLbl.text = "Not available"
                            self.usernameAvailableLbl.textColor = Colors.RED_COLOR
                        } else {
                            self.usernameAvailableLbl.text = "available"
                            self.usernameAvailableLbl.textColor = Colors.GREEN_COLOR
                        }
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                let err = CustomError(description: (error as? CustomError)?.description ?? "")
                print(err.description ?? "")
            }
        }
    }
    
    private func setupSecretQuestionField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.secretQuestionActivityIndicator.isHidden = isLoading ? false : true
            self.secretQuestionField.rightImage = isLoading ? nil : Icons.SIGNUP_ARROW_DOWN_ICON
            if isLoading {
                self.secretQuestionActivityIndicator.startAnimating()
            } else {
                self.secretQuestionActivityIndicator.stopAnimating()
            }
        }
    }
    
    private func getSecretQuestions() {
        setupSecretQuestionField(isLoading: true)
        
        let url = API.Common.getSecretQuestions
        HooleyAPIGeneric<GetCountriesResponseModel>.fetchRequest(apiURL: url) {  [weak self] (result) in
            DispatchQueue.main.async {
                
                guard let `self` = self else { return }
                
                switch result {
                case .success(let responseModel):
                    self.setupSecretQuestionField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.secretQuestionsList = responseModel.data ?? []
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
    
    private func createOTPAPICall(isResend: Bool) {
        
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) ?? ""
        
        let url = API.Account.createOTP  + "/\(sessionId)"
        
        if isResend {
            showProgressHud()
        }
        HooleyAPIGeneric<StringResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            DispatchQueue.main.async {
                
                guard let `self` = self else { return }
                
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    self.setupSecretQuestionField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.conversationId = responseModel.data ?? ""
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
    
    private func verifyOTPAPICall() {
        let otp1 = otpField1.text ?? ""
        let otp2 = otpField2.text ?? ""
        let otp3 = otpField3.text ?? ""
        let otp4 = otpField4.text ?? ""
        let otp5 = otpField5.text ?? ""
        let otp6 = otpField6.text ?? ""
        
        let otpStr = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) as? String ?? ""
        
        let requestModel = VerifyOTPRequestModel(username: userName, password: password, secretQuestionID: selectedSecretQuestion?.id ?? 0, secretAnswer: answer, otp: otpStr, sessionID: sessionId, coversationID: conversationId)
        
        showProgressHud()
        HooleyPostAPIGeneric<VerifyOTPRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.verifyOTP, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        
                        self.alertWithTwoOptions(title: K.ERROR, alertMessage: responseModel.messages ?? "", buttonYesTitle: "Try Again", buttonCancelTitle: "Cancel") {
                            ModeSelection.instance.signupMode()
                        } actionCancel: {
                            print("cancel")
                        }
                        
                    }else{
//                        self.alertMessage(title: "Congratulations", alertMessage: "You have successful registered your account. Please sign in to start MOVOing.", action: {
//                            ModeSelection.instance.signupMode()
//                        })
                        Router.shared.openSignupSuccessfullViewController(controller: self)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")

                    self.alertWithTwoOptions(title: K.ERROR, alertMessage: err.description ?? "", buttonYesTitle: "Try Again", buttonCancelTitle: "Cancel") {
                        ModeSelection.instance.signupMode()
                    } actionCancel: {
                        print("cancel")
                    }
                    
                }
            }
        }
    }
}


extension PersonalDetailThirdTableViewController : UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{

            case otpField1:
                otpField2.becomeFirstResponder()
            case otpField2:
                otpField3.becomeFirstResponder()
            case otpField3:
                otpField4.becomeFirstResponder()
            case otpField4:
                otpField5.becomeFirstResponder()
            case otpField5:
                otpField6.becomeFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otpField1:
                otpField1.becomeFirstResponder()
            case otpField2:
                otpField1.becomeFirstResponder()
            case otpField3:
                otpField2.becomeFirstResponder()
            case otpField4:
                otpField3.becomeFirstResponder()
            case otpField5:
                otpField4.becomeFirstResponder()
            case otpField6:
                otpField5.becomeFirstResponder()
            default:
                break
            }
        }
        else{

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        let count = textField.text?.count ?? 0
        if count >= 1 {
            return false
        } else {
            if textField == otpField1{
                if string.count > 0{
                    currentTextField = otpField2
                }else{
                    return false
                }
            }else if textField == otpField2{
                if string.count > 0{
                    currentTextField = otpField3
                }else{
                    return false
                }
            }else if textField == otpField3{
                if string.count > 0{
                    currentTextField = otpField4
                }else{
                    return false
                }
            }else if textField == otpField4{
                if string.count > 0{
                    currentTextField = otpField5
                }else{
                    return false
                }
            }else if textField == otpField5{
                if string.count > 0{
                    currentTextField = otpField6
                }else{
                    return false
                }
            }
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(nextField), userInfo: nil, repeats: false)
            
            return true
        }
    }
    
    @objc private func nextField() -> Void {
        currentTextField.becomeFirstResponder()
    }
}
