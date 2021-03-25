//
//  EditScheduleBankTransferViewController.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import UIKit

class EditScheduleBankTransferViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var transferModel : TransferModel?
    
    private var selectedCard : CardModel?
    private var selectedBank : AccountModel?
    private var accountsList = [AccountModel]()

    private var amount: String?
    private var selectedFrequency : FrequencyType?
    private var selectedDate: Date?
    private var commentsStr = ""
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CashOutToBankTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankTableViewCell.className)
        tableView.register(UINib(nibName: CashOutToBankCommentsTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankCommentsTableViewCell.className)
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        if let model = transferModel {
            amount = model.amount
            
            let apiDate = model.transferDate?.getOnlyDateStr().getLocalDate() ?? Date()
            let currentDate = Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString().getOnlyDateStr().getLocalDate()
            if apiDate <= currentDate {
                selectedFrequency = FrequencyType.once
            } else {
                selectedFrequency = FrequencyType.date
                selectedDate = apiDate
            }
           
            if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
                let array  = cardModel.cards
                let primaryCards = array?.filter({Common.shared.isPrimaryCard(model: $0)}) ?? []
                if let index = primaryCards.lastIndex(where: {$0.cardNumber == model.transferFrom}) {
                    selectedCard = primaryCards[index]
                }
            }
        }
        
        getCardAccounts()
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        
        if selectedCard == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select card", action: nil)
            return
        }
        
        if selectedBank == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select bank", action: nil)
            return
        }
        
        if amount == nil || amount == "" || amount == "0.0" {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select amount", action: nil)
            return
        }
        
        let amounDouble = Double(amount ?? "0.0") ?? 0.0
        let cardBalance = Double(selectedCard?.balance ?? "0.0") ?? 0.0
        
        if amounDouble > cardBalance {
            self.alertMessage(title: K.ALERT, alertMessage: Alerts.NOT_AVAILABLE_BALANCE, action: nil)
            return
        }
        
        if selectedFrequency == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select frequency", action: nil)
            return
        }
        
        if selectedFrequency == FrequencyType.date {
            if selectedDate == nil {
                self.alertMessage(title: K.ALERT, alertMessage: "Please select scheduled date", action: nil)
                return
            }
        }
        
        let amountStr = amounDouble.numberFormatter(digitAfterPoint: 2)
        let requestModel = CashToBankTransferRequestModel(transferID: transferModel?.transferID ?? "", accountSrNo: selectedBank?.accountSrNo, amount: amountStr, transferComments: commentsStr, transferFrequency: selectedFrequency?.rawValue, transferDate: selectedFrequency == FrequencyType.once ? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString() : selectedDate?.convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString())
        
        self.editTransferAPICall(requestModel: requestModel)
    }
    

}

extension EditScheduleBankTransferViewController : UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CashOutToBankTableViewCell.className, for: indexPath) as! CashOutToBankTableViewCell
            
            cell.configureCell(selectedCard: selectedCard, SelectedBank: selectedBank, selectedFrequency: selectedFrequency, scheduleDate: selectedDate?.convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString(), amount: amount ?? "")
            cell.selectCardTapped = {
                Router.shared.openSelectAccountPopupVC(delegateView: self.view, isViewDelegate: false, isOnlyShowPrimaryAccounts: true, selectedCard: nil, controller: self)
            }
            
            cell.selectBankTapped = {
                
                if self.accountsList.isEmpty {
                    return
                }
                
                var strArray = [String]()
                self.accountsList.forEach { (model) in
                    strArray.append(model.bankName ?? "")
                }
                
                if strArray.isEmpty {
                    self.alertMessage(title: K.ALERT, alertMessage: "No account found", action: {})
                    return
                }
                
                Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Account", selectedValue: self.selectedBank == nil ? strArray[0] : self.selectedBank?.bankName ?? "", controller: self, dataPickedHandler: { (index, value) in
                    self.selectedBank = self.accountsList[index]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
            }
            
            cell.amountFieldTextChanged = { value in
                self.amount = value
            }
            
            cell.selectFrequencyTapped = {
                if self.transferModel != nil && self.selectedFrequency == FrequencyType.once {
                    return
                }
                Router.shared.openSelectTransferFrequencyPopupVC(delegateView: self.view, isViewDelegate: true, controller: self)
            }
            
            cell.scheduleDateButtonTapped = {
                let minDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                Router.shared.openSetDateTimePopUPVC(title: "Select Date", minumumDate: minDate, maximumDate: nil, alreadySelectedDate: nil, isDateOnly: true, controller: self) { (date) in
                    self.selectedDate = date
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CashOutToBankCommentsTableViewCell.className, for: indexPath) as! CashOutToBankCommentsTableViewCell
            cell.textChanged = { str in
                self.commentsStr = str
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        default:
            return 200
        }
    }
}

extension EditScheduleBankTransferViewController : SelectAccountPopupVCDelegate, SelectTransferFrequencyPopupVCDelegate {
    func getSelectedAccount(model: CardModel?) {
        selectedCard = model
        tableView.reloadData()
    }
    
    func getSelectedFrequency(frequency: FrequencyType) {
        selectedFrequency = frequency
        tableView.reloadData()
    }
}

extension EditScheduleBankTransferViewController {
    private func getCardAccounts() {
        
        showProgressHud()
        
        let url = API.Banking.bankaccountslist
        HooleyAPIGeneric<MyBankAccountsResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    } else {
                        self.accountsList = responseModel.data?.accounts ?? []
                        if let m = self.transferModel {
                            if let index = self.accountsList.lastIndex(where: {$0.accountNumber == m.transferTo}) {
                                self.selectedBank = self.accountsList[index]
                                self.tableView.reloadData()
                            }
                        }
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    func editTransferAPICall(requestModel: CashToBankTransferRequestModel) {
        
        showProgressHud()
        HooleyPostAPIGeneric<CashToBankTransferRequestModel, CashToBankTransferResponseModel>.postRequest(apiURL: API.Banking.c2btransferupdate, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.alertMessage(title: K.SUCCESS, alertMessage: responseModel.data?.responseDesc ?? "") {
                            self.navigationController?.popToRootViewController(animated: true)
                            NotificationCenter.default.post(name: .REFRESH_SCHEDULED_TRANSFER_SCREEN, object: nil)
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
