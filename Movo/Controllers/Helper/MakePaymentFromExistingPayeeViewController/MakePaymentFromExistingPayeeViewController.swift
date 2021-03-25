//
//  MakePaymentFromExistingPayeeViewController.swift
//  Movo
//
//  Created by Ahmad on 27/12/2020.
//

import UIKit

class MakePaymentFromExistingPayeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedCard : CardModel?
    private var amountStr: String?
    private var selectedDate: Date?
    private var commentsStr = ""
    private var payeesArray = [PayeeModel]()
    
    var selectedPayee : PayeeModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: MakePaymentTableViewCell.className, bundle: nil), forCellReuseIdentifier: MakePaymentTableViewCell.className)
        tableView.register(UINib(nibName: CashOutToBankCommentsTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashOutToBankCommentsTableViewCell.className)
        tableView.tableFooterView = UIView()
        
        getCardHolderPayeeList()
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        if selectedPayee == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select Payee", action: nil)
            return
        }
        
        if selectedCard == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select card", action: nil)
            return
        }
                
        if amountStr == nil || amountStr == "" || amountStr == "0.0" {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select amount", action: nil)
            return
        }
        
        let amounDouble = Double(amountStr ?? "0.0") ?? 0.0
        let cardBalance = Double(selectedCard?.balance ?? "0.0") ?? 0.0
        
        if amounDouble > cardBalance {
            self.alertMessage(title: K.ALERT, alertMessage: Alerts.NOT_AVAILABLE_BALANCE, action: nil)
            return
        }
        
        if selectedDate == nil {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select date", action: nil)
            return
        }
        
        let amountStr = amounDouble.numberFormatter(digitAfterPoint: 2)
        
        let customModel = CustomMakePaymentModel(payeeName: selectedPayee?.payeeName, selectedPayment: nil, selectedCard: selectedCard)
        let requestModel = MakePaymentRequestModel(tansID: "", payeeSrNo: selectedPayee?.payeeSerialNo ?? "", payeeAccountNumber: selectedPayee?.payeeAccountNumber ?? "", amount: amountStr, paymentDate: selectedDate?.convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString(), comments: commentsStr)
        Router.shared.openMakePaymentReceiptViewController(isFromPayButton: true, requestModel: requestModel, customModel: customModel, controller: self)
    }
    
    //MARK:- UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MakePaymentTableViewCell.className, for: indexPath) as! MakePaymentTableViewCell
            cell.configureCell(SelectedPayee: selectedPayee, selectedCard: selectedCard, scheduleDate: selectedDate?.convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString(), amount: amountStr ?? "")
            cell.selectionStyle = .none
            
            cell.payeeButtonTapped = {
                var strArray = [String]()
                self.payeesArray.forEach { (model) in
                    strArray.append(model.payeeName ?? "")
                }
                
                if strArray.isEmpty {
                    self.alertMessage(title: K.ALERT, alertMessage: "No Payee found", action: {})
                    return
                }
                
                Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select Payee", selectedValue: self.selectedPayee == nil ? strArray[0] : self.selectedPayee?.payeeName ?? "", controller: self, dataPickedHandler: { (index, value) in
                    self.selectedPayee = self.payeesArray[index]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
            cell.cardButtonTapped = {
                Router.shared.openSelectAccountPopupVC(delegateView: self.view, isViewDelegate: false, isOnlyShowPrimaryAccounts: true, selectedCard: self.selectedCard, controller: self)
            }
            
            cell.amountTextChanged = { str in
                self.amountStr = str
            }
            cell.dateButtonTapped = {
                let minDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                Router.shared.openSetDateTimePopUPVC(minumumDate: minDate,
                                                     maximumDate: nil,
                                                     alreadySelectedDate: nil,
                                                     isDateOnly: true,
                                                     controller: self) { (value) in
                    self.selectedDate = value
                    self.tableView.reloadData()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CashOutToBankCommentsTableViewCell.className, for: indexPath) as! CashOutToBankCommentsTableViewCell
            cell.textChanged = { str in
                self.commentsStr = str
            }
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

extension MakePaymentFromExistingPayeeViewController : SelectAccountPopupVCDelegate {
    func getSelectedAccount(model: CardModel?) {
        selectedCard = model
        self.tableView.reloadData()
    }
}

extension MakePaymentFromExistingPayeeViewController {
    private func getCardHolderPayeeList() {
        showProgressHud()
        
        let url = API.ECheckbook.getcardholderpayeelist
        HooleyAPIGeneric<GetCardHolderListResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.payeesArray = responseModel.data?.payees ?? []
                        if let index = self.payeesArray.lastIndex(where: {$0.payeeSerialNo == self.selectedPayee?.payeeSerialNo}) {
                            self.selectedPayee = self.payeesArray[index]
                            self.tableView.reloadData()
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
