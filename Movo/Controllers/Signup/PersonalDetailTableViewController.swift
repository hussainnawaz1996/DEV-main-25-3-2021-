//
//  PersonalDetailTableViewController.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit
import ActiveLabel

class PersonalDetailTableViewController: UITableViewController {
    @IBOutlet var topButtons: [CircularSelectionButton]!
    @IBOutlet weak var typeSelectionField: WhiteBorderedTextfield!
    @IBOutlet weak var firstNameField: WhiteBorderedTextfield!
    @IBOutlet weak var lastNameField: WhiteBorderedTextfield!
    @IBOutlet weak var socialSecurityNumberField: WhiteBorderedTextfield!
    @IBOutlet weak var dobField: WhiteBorderedTextfield!
    @IBOutlet weak var emailField: WhiteBorderedTextfield!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var cellNumberField: WhiteBorderedTextfield!
    @IBOutlet weak var addressLineField: WhiteBorderedTextfield!
    @IBOutlet weak var cityField: WhiteBorderedTextfield!
    @IBOutlet weak var maleButton: RadioButton!
    @IBOutlet weak var femaleButton: RadioButton!
    @IBOutlet weak var stateField: WhiteBorderedTextfield!
    @IBOutlet weak var zipCodeField: WhiteBorderedTextfield!
    
    @IBOutlet weak var emailAvailableLbl: UILabel!
    @IBOutlet weak var emailActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stateActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var typeSelectionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryField: WhiteBorderedTextfield!
    @IBOutlet weak var countryActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var agreeLabel: ActiveLabel!
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var privacyAgreeButton: UIButton!
    @IBOutlet weak var privacyAgreeLabel: ActiveLabel!
    
    private var firstName = ""
    private var lastName = ""
    private var socialSecurityNumber = ""
    private var dob = ""
    private var isMale = true
    private var email = ""
    private var countryCode = "+1"
    private var cellNumber = ""
    private var addressLine = ""
    private var city = ""
    private var zip = ""
    private var isTermsButtonTapped = false
    private var isPrivacyButtonTapped = false
    private var countriesArray = [NameIdModel]()
    private var statesArray = [NameIdModel]()
    private var identificationTypes = [NameIdModel]()
    private var selectedCountry :NameIdModel?
    private var selectedState : NameIdModel?
    private var selectedIdentificationType : NameIdModel?
    private var isEmailAlreadyExists = false
    
    var customSignupModel : CustomSignupModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cellNumberField.delegate = self
        initCustomSignupModel()
        setupView()
        getCountries()
        getIdentificationTypes()
        
//        let model = CustomSignupModel(email: "", phoneNumber: "", photosModel: nil, user3rdScreenModel: nil)
//        Router.shared.openPersonalDetailSecondTableViewController(customSignupModel: model, controller: self)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        topButtons.forEach { (button) in
            if button.tag == 0 {
                button.enable()
            } else {
                button.disable()
            }
        }
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.performProfiling()
        }
    }
    
    //MARK:- Helper Methods
    private func setupView() {
        typeSelectionActivityIndicator.isHidden = true
        stateActivityIndicator.isHidden = true
        countryActivityIndicator.isHidden = true
        emailActivityIndicator.isHidden = true
        emailAvailableLbl.isHidden = true
        
        
        dobField.rightImage = UIImage(named:"calendar_icon")
        typeSelectionField.rightImage = Icons.SIGNUP_ARROW_DOWN_ICON
//        countryField.rightImage = Icons.SIGNUP_ARROW_DOWN_ICON
        stateField.rightImage = Icons.SIGNUP_ARROW_DOWN_ICON
        maleButton.enable()
        femaleButton.disable()
        
        setupAgreeLabel()
        setupPrivacyAgreeLabel()
        
        firstNameField.textChanged = { str in
            self.firstName = str
        }
        
        lastNameField.textChanged = { str in
            self.lastName = str
        }
        
        socialSecurityNumberField.textChanged = { str in
            self.socialSecurityNumber = str
        }
        
        emailField.textChanged = { str in
            self.email = str
        }
        
        cellNumberField.textChanged = { str in
            self.cellNumber = str
        }
        
        addressLineField.textChanged = { str in
            self.addressLine = str
        }
        
        cityField.textChanged = { str in
            self.city = str
        }
        
        zipCodeField.textChanged = { str in
            self.zip = str
        }
    }
    
    private func setupAgreeLabel() {
        let customType = ActiveType.custom(pattern: "\\sTerms & Conditions\\b") //Regex that looks for "with"
        agreeLabel.enabledTypes = [customType]
        agreeLabel.text = "I agree with the Terms & Conditions and electronic communication."
        
        agreeLabel.textColor = Colors.BLACK
        agreeLabel.customColor[customType] = Colors.RED_COLOR
        agreeLabel.customSelectedColor[customType] = Colors.RED_COLOR
        agreeLabel.highlightFontName = "Helvetica-Bold"
        agreeLabel.highlightFontSize = 13

        agreeLabel.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            Router.shared.openWebViewController(urlStr: WebUrls.cardHolderAgreement, controller: self)
        }
    }
    
    private func setupPrivacyAgreeLabel() {
        let customType = ActiveType.custom(pattern: "\\sCoastal Community Bank Privacy Policy\\b") //Regex that looks for "with"
        let customType2 = ActiveType.custom(pattern: "\\sMOVO® Privacy Policy\\b") //Regex that looks for "with"

        privacyAgreeLabel.enabledTypes = [customType, customType2]
        privacyAgreeLabel.setAttributedTextWithSubscripts(str: "I agree with the Coastal Community Bank Privacy Policy and MOVO® Privacy Policy")

        privacyAgreeLabel.textColor = Colors.BLACK
        
        privacyAgreeLabel.customColor[customType] = Colors.RED_COLOR
        privacyAgreeLabel.customSelectedColor[customType] = Colors.RED_COLOR
        privacyAgreeLabel.highlightFontName = "Helvetica-Bold"
        privacyAgreeLabel.highlightFontSize = 13
        
        privacyAgreeLabel.customColor[customType2] = Colors.RED_COLOR
        privacyAgreeLabel.customSelectedColor[customType2] = Colors.RED_COLOR
        privacyAgreeLabel.highlightFontName = "Helvetica-Bold"
        privacyAgreeLabel.highlightFontSize = 13
        
        privacyAgreeLabel.handleCustomTap(for: customType) { element in
            Router.shared.openWebViewController(urlStr: WebUrls.coastalCommunityPrivacyPolicy, controller: self)
        }
        
        privacyAgreeLabel.handleCustomTap(for: customType2) { element in
            Router.shared.openWebViewController(urlStr: WebUrls.movoPrivacyPolicy, controller: self)
        }
    }
    
    private func setupCountryField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.countryActivityIndicator.isHidden = isLoading ? false : true
            if isLoading {
                self.countryActivityIndicator.startAnimating()
            } else {
                self.countryActivityIndicator.stopAnimating()
            }
//            self.countryField.rightImage = isLoading ? nil : Icons.SIGNUP_ARROW_DOWN_ICON
        }
    }
    
    private func setupStateField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.stateActivityIndicator.isHidden = isLoading ? false : true
            if isLoading {
                self.stateActivityIndicator.startAnimating()
            } else {
                self.stateActivityIndicator.stopAnimating()
            }
            self.stateField.rightImage = isLoading ? nil : Icons.SIGNUP_ARROW_DOWN_ICON
        }
    }
    
    private func setupTypeSelectionField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.typeSelectionActivityIndicator.isHidden = isLoading ? false : true
            if isLoading {
                self.typeSelectionActivityIndicator.startAnimating()
            } else {
                self.typeSelectionActivityIndicator.stopAnimating()
            }
            self.typeSelectionField.rightImage = nil
//            self.typeSelectionField.rightImage = isLoading ? nil : Icons.SIGNUP_ARROW_DOWN_ICON
        }
    }
    
    private func initCustomSignupModel() {
        
        let photosModel = PhotosModel(frontImage: nil, backImage: nil, selfieImage: nil)
        
        let selectedQuestion = NameIdModel(id: nil, name: nil)
        let user3rdScreenModel = User3rdScreenModel(userName: nil, password: nil, selectedSecretQuestion: selectedQuestion, answer: nil, isRememberMe: nil)
        
        customSignupModel = CustomSignupModel(email: "", phoneNumber: "", photosModel: photosModel, user3rdScreenModel : user3rdScreenModel)
    }
    
    private func syncData() {
        let phoneNumber = self.countryCode + self.cellNumber
        self.customSignupModel?.email = self.email
        self.customSignupModel?.phoneNumber = phoneNumber
    }
    
    //MARK:- IBActions
    @IBAction func countryCodeButtonWasPressed(_ sender: UIButton) {
        openCountryPicker { [weak self] (name, code, dialCode) in
            guard let `self` = self else{ return }
            self.countryCode = dialCode
            self.countryCodeButton.setTitle(dialCode, for: .normal)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func typeSelectionButtonWasPressed(_ sender: UIButton) {
//        if identificationTypes.isEmpty {
//            return
//        }
//
//        var strArray = [String]()
//        identificationTypes.forEach { (model) in
//            strArray.append(model.name ?? "")
//        }
//
//        Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Type", selectedValue: strArray[0], controller: self, dataPickedHandler: { (index, value) in
//            if let index = self.identificationTypes.lastIndex(where: {$0.name == value}) {
//                self.selectedIdentificationType = self.identificationTypes[index]
//                self.typeSelectionField.text = self.selectedIdentificationType?.name
//            }
//        })
    }
    
    @IBAction func maleButtonWasPressed(_ sender: RadioButton) {
        isMale = true
        maleButton.enable()
        femaleButton.disable()
    }
    
    @IBAction func femaleButtonWasPressed(_ sender: RadioButton) {
        isMale = false
        maleButton.disable()
        femaleButton.enable()
    }
    
    @IBAction func dobButtonWasPressed(_ sender: UIButton) {
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let defaultSelectedDate = "1990-01-01T00:00:00".getDateFromString()
        let alreadySelectedDate = dob.isEmpty ? defaultSelectedDate : dob.getDateFromString()

        Router.shared.openSetDateTimePopUPVC(minumumDate: nil,
                                             maximumDate: maxDate,
                                             alreadySelectedDate: alreadySelectedDate,
                                             isDateOnly: true,
                                             controller: self) { (value) in
            self.dob = value?.getStringFromDate().getOnlyDateStr() ?? ""
            self.dobField.text = value?.getEventDisplayDate()
        }
    }
    
    @IBAction func stateButtonWasPressed(_ sender: UIButton) {
        if statesArray.isEmpty {
            return
        }
        
        var strArray = [String]()
        statesArray.forEach { (model) in
            strArray.append(model.name ?? "")
        }
        
        let selectedValue = selectedState == nil ? strArray[0] : selectedState?.name ?? ""
        
        Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select State", selectedValue: selectedValue, controller: self, dataPickedHandler: { (index, value) in
            if let index = self.statesArray.lastIndex(where: {$0.name == value}) {
                self.selectedState = self.statesArray[index]
                self.stateField.text = self.selectedState?.name
            }
        })
    }
    
    @IBAction func countryButtonWasPressed(_ sender: UIButton) {
        
        //this is to show only USA, stop selection of different country
//        if countriesArray.isEmpty {
//            return
//        }
//
//        var strArray = [String]()
//        countriesArray.forEach { (model) in
//            strArray.append(model.name ?? "")
//        }
//
//        Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Country", selectedValue: strArray[0], controller: self, dataPickedHandler: { (index, value) in
//            if let index = self.countriesArray.lastIndex(where: {$0.name == value}) {
//                self.selectedCountry = self.countriesArray[index]
//                self.getStates()
//            }
//        })
    }
    
    @IBAction func agreeButtonWasPressed(_ sender: UIButton) {
        isTermsButtonTapped = !isTermsButtonTapped
        let img = isTermsButtonTapped ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED
        agreeButton.setImage(img, for: .normal)
        
    }
    
    @IBAction func privacyAgreeButtonWasPressed(_ sender: UIButton) {
        isPrivacyButtonTapped = !isPrivacyButtonTapped
        let img = isPrivacyButtonTapped ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED
        privacyAgreeButton.setImage(img, for: .normal)
    }
    
    @IBAction func emailFieldChanged(_ sender: UITextField) {
        if email.isEmpty || (email.isValidEmail() == false) {
            emailAvailableLbl.isHidden = true
            return
        }
        
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(isEmailExistsAPICall), object: nil)
//        self.perform(#selector(isEmailExistsAPICall), with: nil, afterDelay: 3.0)
    }
    
    @IBAction func continueButtonWasPressed(_ sender: BlackBGButton) {
        let result = validation()
        if result.status {
            syncData()
            signupAPICall()
        } else {
            alertMessage(title: K.ALERT, alertMessage: result.msg, action: nil)
        }
    }
    
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func validation() -> (msg: String, status: Bool) {
        
        if firstName.isEmpty {
            return ("First name is missing", false)
        }
        
        if lastName.isEmpty {
            return ("Last name is missing", false)
        }
        
        if selectedIdentificationType == nil {
            return ("id type is missing", false)
        }
        
        if dob.isEmpty {
            return ("Date of birth is missing", false)
        }
        
        if email.isEmpty {
            return ("email is missing", false)
        }
        
        if email.isValidEmail() == false {
            return ("email is invalid", false)
        }
        
        if cellNumber.isEmpty {
            return ("cell number is missing", false)
        }
        
        if addressLine.isEmpty {
            return ("address line is missing", false)
        }
        
        if city.isEmpty {
            return ("city is missing", false)
        }
                
        if zip.isEmpty {
            return ("zip code is missing", false)
        }
        
        if selectedCountry == nil {
            return ("country is missing", false)
        }
        
        if isTermsButtonTapped == false {
            return ("please agree to our terms", false)
        }
        
        if isPrivacyButtonTapped == false {
            return ("please agree to our privacy", false)
        }
        
        if isEmailAlreadyExists == true {
            return ("This email already exists", false)
        }
        
        return ("", true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 3:
            return 0 // for SSN field
        case 6:
            return emailAvailableLbl.isHidden ? 50 : 60
        case 11:
            return 50
        case 12:
            return 60
        case 13:
            return 40
        case 14:
            return 30
        default:
            return 50
        }
    }
    
}


extension PersonalDetailTableViewController {
    //MARK:- API Calls
    private func getCountries() -> Void {
        self.setupCountryField(isLoading: true)
        let url = API.Common.getcountries
        HooleyAPIGeneric<GetCountriesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                
                switch result {
                case .success(let responseModel):
                    self.setupCountryField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.countriesArray = responseModel.data ?? []
                        if let index = self.countriesArray.lastIndex(where: {$0.id == UnitedStatesId}) {
                            self.selectedCountry = self.countriesArray[index]
                            self.countryField.text = self.selectedCountry?.name
                            self.getStates()
                        }
                        
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
    
    private func getStates() -> Void {
        self.setupStateField(isLoading: true)
        let countryId = selectedCountry?.id ?? 0
        let url = API.Common.getstates + "/\(countryId)"
        HooleyAPIGeneric<GetCountriesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                
                switch result {
                case .success(let responseModel):
                    self.setupStateField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.statesArray = responseModel.data ?? []
                        self.selectedState = self.statesArray.first
                        self.stateField.text = self.selectedState?.name
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getIdentificationTypes() -> Void {
        self.setupTypeSelectionField(isLoading: true)
        let url = API.Common.getidentificationtypes
        HooleyAPIGeneric<GetCountriesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                
                switch result {
                case .success(let responseModel):
                    self.setupTypeSelectionField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.identificationTypes = responseModel.data ?? []
                        self.selectedIdentificationType = self.identificationTypes.first
                        self.typeSelectionField.text = self.selectedIdentificationType?.name
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    print(err.description ?? "")
                }
            }
        }
    }
    
    private func signupAPICall() {
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) as? String ?? ""
        let sessionIdResponse = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionIdResponse) as? String ?? ""

        let requestModel = SignupRequestModel(firstName: firstName, lastName: lastName, identificationTypeID: selectedIdentificationType?.id ?? 0, identificationValue: socialSecurityNumber, dateOfBirth: dob, genderID: isMale ? GenderType.male.rawValue : GenderType.female.rawValue, email: email, cellCountryCode: countryCode, cellPhoneNumber: cellNumber, addressLine1: addressLine, countryID: selectedCountry?.id ?? 0, stateID: selectedState?.id ?? 0, city: city, zipCode: zip, lnSessionID: sessionId, lnSessionIDResponse: sessionIdResponse)
                    
        showProgressHud()
        HooleyPostAPIGeneric<SignupRequestModel, SignupResponseModel>.postRequest(apiURL: API.Account.signup, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):

                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages, action: nil)
                    }else{
                        Router.shared.openPersonalDetailSecondTableViewController(customSignupModel: self.customSignupModel, controller: self)
                    }

                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    @objc private func isEmailExistsAPICall() {
        
        self.emailAvailableLbl.isHidden = false
        self.emailAvailableLbl.textColor = Colors.BLACK
        self.emailAvailableLbl.text = "Checking..."
        self.setupEmailField(isLoading: true)
        tableView.reloadData()

        let url = API.Account.isEmailExists + "/\(email)"
        HooleyAPIGeneric<BoolResponseModel>.fetchRequest(apiURL: url) { (result) in
            switch result {
            case .success(let responseModel):
                DispatchQueue.main.async {
                    self.setupEmailField(isLoading: false)
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.isEmailAlreadyExists = responseModel.data ?? false
                        if responseModel.data ?? false {
                            self.emailAvailableLbl.text = "Not available"
                            self.emailAvailableLbl.textColor = Colors.RED_COLOR
                        } else {
                            self.emailAvailableLbl.text = "available"
                            self.emailAvailableLbl.textColor = Colors.GREEN_COLOR
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
    
    private func setupEmailField(isLoading: Bool) {
        DispatchQueue.main.async {
            self.emailActivityIndicator.isHidden = isLoading ? false : true
            if isLoading {
                self.emailActivityIndicator.startAnimating()
            } else {
                self.emailActivityIndicator.stopAnimating()
            }
        }
    }
}

extension PersonalDetailTableViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == socialSecurityNumberField {
            textField.isSecureTextEntry = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == socialSecurityNumberField {
            textField.isSecureTextEntry = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
                        
        if textField == socialSecurityNumberField {
            if textField.text!.count < 9 {
                return true
            }else{
                return false
            }
        }
        if textField == cellNumberField {
            if textField.text!.count < 10 {
                return true
            }else{
                return false
            }
        }
        
        if textField == zipCodeField {
            if textField.text!.count < 5 {
                return true
            }else{
                return false
            }
        }
        return true
    }
}

extension PersonalDetailTableViewController :  PersonalDetailSecondTableViewControllerDelegate {
    func secondScreenDismiss(model: CustomSignupModel?) {
        customSignupModel = model
    }
}
