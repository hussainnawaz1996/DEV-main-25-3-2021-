//
//  CashOutToBankView.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class CashOutToBankView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedCard : CardModel?
    private var selectedBank : AccountModel?
    private var accountsList = [AccountModel]()

    private var amount: String?
    private var selectedFrequency : FrequencyType?
    private var selectedDate: Date?
    private var commentsStr = ""
    
    var controller: UIViewController? = nil
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: CashOutToBankTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankTableViewCell.className)
        tableView.register(UINib(nibName: CashOutToBankCommentsTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankCommentsTableViewCell.className)
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func setup() {
        getCardAccounts()
    }
    
    func nextButtonWasPressed() {
        if selectedCard == nil {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please select card", action: nil)
            return
        }
        
        if selectedBank == nil {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please select bank", action: nil)
            return
        }
        
        if amount == nil || amount == "" || amount == "0.0" {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please select amount", action: nil)
            return
        }
        
        let amounDouble = Double(amount ?? "0.0") ?? 0.0
        let cardBalance = Double(selectedCard?.balance ?? "0.0") ?? 0.0
        
        if amounDouble > cardBalance {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: Alerts.NOT_AVAILABLE_BALANCE, action: nil)
            return
        }
        
        if selectedFrequency == nil {
            self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please select frequency", action: nil)
            return
        }
        
        if selectedFrequency == FrequencyType.date {
            if selectedDate == nil {
                self.controller!.alertMessage(title: K.ALERT, alertMessage: "Please select scheduled date", action: nil)
                return
            }
        }
        
        let amountStr = amounDouble.numberFormatter(digitAfterPoint: 2)
        let requestModel = CashToBankTransferRequestModel(transferID: "", accountSrNo: selectedBank?.accountSrNo, amount: amountStr, transferComments: commentsStr, transferFrequency: selectedFrequency?.rawValue, transferDate: selectedFrequency == FrequencyType.once ? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString() : selectedDate?.convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString())
        
        Router.shared.openCardToBankReceiptViewController(requestModel: requestModel, selectedCard: selectedCard, selectedBank: selectedBank, controller: self.controller!)
    }

    
}

extension CashOutToBankView : UITableViewDelegate, UITableViewDataSource {
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
                Router.shared.openSelectAccountPopupVC(delegateView: self, isViewDelegate: true, isOnlyShowPrimaryAccounts: true, selectedCard: nil, controller: self.controller!)
            }
            
            cell.selectBankTapped = {
                if self.accountsList.isEmpty {
                    self.controller!.alertMessage(title: K.ALERT, alertMessage: "No Account Found", action: nil)
                    return
                }
                
                var strArray = [String]()
                self.accountsList.forEach { (model) in
                    strArray.append(model.bankName ?? "")
                }
                
                if strArray.isEmpty {
                    self.controller?.alertMessage(title: K.ALERT, alertMessage: "No Account found", action: {})
                    return
                }
                
                Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Account", selectedValue: self.selectedBank == nil ? strArray[0] : self.selectedBank?.bankName ?? "", controller: self.controller!, dataPickedHandler: { (index, value) in
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
                Router.shared.openSelectTransferFrequencyPopupVC(delegateView: self, isViewDelegate: true, controller: self.controller!)
            }
            
            cell.scheduleDateButtonTapped = {
                let minDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                Router.shared.openSetDateTimePopUPVC(title: "Select Date", minumumDate: minDate, maximumDate: nil, alreadySelectedDate: nil, isDateOnly: true, controller: self.controller!) { (date) in
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

extension CashOutToBankView : SelectAccountPopupVCDelegate, SelectTransferFrequencyPopupVCDelegate {
    func getSelectedAccount(model: CardModel?) {
        selectedCard = model
        tableView.reloadData()
    }
    
    func getSelectedFrequency(frequency: FrequencyType) {
        selectedFrequency = frequency
        tableView.reloadData()
    }
}

extension CashOutToBankView {
    private func getCardAccounts() {
        
        showProgressOnView()
        
        let url = API.Banking.bankaccountslist
        HooleyAPIGeneric<MyBankAccountsResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    } else {
                        self.accountsList = responseModel.data?.accounts ?? []
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
