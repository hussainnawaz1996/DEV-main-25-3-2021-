//
//  MovoCashAlertsView.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class MovoCashAlertsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerAccountNumberLbl: UILabel!
    @IBOutlet weak var headerAccountBalanceLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    
    private var expandedList = [Bool]()
    private var alertsList = [CashAlertModel]()
//    private let headerArray = ["Debit Transaction Posted", "Update Profile Alert", "Credit Transaction Posted", "Card Balance Threshold", "International Transaction", "PIN Change", "Declined Authorization", "Insufficient Funds on Card Account", "Close Card Account", "Wrong PIN Attempt", "Daily Balance Alert"]
//    private let strArray = [
//        "When an amount less than or equals to $0.01 USD is deducted from this account.",
//        "You will receive an alert when a transaction is declined due to insufficient funds in your card account.",
//        "When an amount less than or equals to $0.01 USD is deducted from this account.",
//        "When an amount less than or equals to $0.01 USD is deducted from this account.",
//        "You will receive a daily alert providing the current available balance on your card account.",
//        "You will receive a daily alert providing the current available balance on your card account.",
//        "You will receive a daily alert providing the current available balance on your card account.",
//        "You will receive a daily alert providing the current available balance on your card account.",
//        "Triggered whenever your card is closed.",
//        "You will receive a daily alert providing the current available balance on your card account.",
//        "You will receive a daily alert providing the current available balance on your card account."
//    ]
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: MovoCashAlertTNoDataTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovoCashAlertTNoDataTableViewCell.className)
        tableView.register(UINib(nibName: MovoCashAlertsAddedInformationTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovoCashAlertsAddedInformationTableViewCell.className)
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getUserAlerts), name: .REFRESH_CASH_ALERTS_SCREEN, object: nil)
    }
    
    func setup() {
        getUserAlerts()
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            if let primaryCard = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                headerAccountNumberLbl.text = Common.shared.getFormattedCardNumber(model: primaryCard)
                headerAccountBalanceLbl.text = "Balance: $" + (primaryCard.balance ?? "0.0") + "USD"
            }
        }
    }
    
    @objc func getUserAlerts() {
        
        showProgressOnView()
        
        let url = API.Account.getuseralerts
        HooleyAPIGeneric<GetUserAlertsResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let`self` = self else { return }
            
            DispatchQueue.main.async {
                self.hideProgressFromView()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.alertsList = responseModel.data ?? []
                        
                        self.expandedList.removeAll()
                        self.alertsList.forEach { (_) in
                            self.expandedList.append(true)
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    //MARK: UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return alertsList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = MovoCashAlertHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        var isShowAddIcon = false
        if alertsList[section].isMultiple == false && (alertsList[section].alerts?.count ?? 0) > 0 {
            isShowAddIcon = false
        } else {
            isShowAddIcon = true
        }
        view.configureView(model: alertsList[section], isExpanded: /*expandedList[section]*/ true, isShowAddButton: isShowAddIcon)
        
        view.headerBtnTapped = {
            self.expandedList[section] = !self.expandedList[section]
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(section...section), with: UITableView.RowAnimation.automatic)
            }
        }
        
        view.addButtonTapped = {
            self.goToEditScreen(section: section, row: -1, isAddButton: true)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let alerts = alertsList[section].alerts ?? []
        return alerts.count == 0 ? 1 : alerts.count
//        return expandedList[section] ? 1 : alerts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alerts = alertsList[indexPath.section].alerts ?? []
        if alerts.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovoCashAlertTNoDataTableViewCell.className, for: indexPath) as! MovoCashAlertTNoDataTableViewCell
            cell.configureCell(description: alertsList[indexPath.section].datumDescription ?? "")
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovoCashAlertsAddedInformationTableViewCell.className, for: indexPath) as! MovoCashAlertsAddedInformationTableViewCell
            cell.configureCell(model: alerts[indexPath.row], isOperator: alertsList[indexPath.section].isOperator ?? false)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditScreen(section: indexPath.section, row: indexPath.row)
    }
    
    private func goToEditScreen(section: Int, row: Int, isAddButton: Bool = false) {
        var customModel = CustomCashAlertModel(title: alertsList[section].name, decsription: alertsList[section].datumDescription, isOperator: alertsList[section].isOperator, model: nil)
        
        if isAddButton {
            customModel.model = getEmptyModel(section: section)
            Router.shared.openEditMovoCashAlertsViewController(customModel: customModel, controller: controller!)
        } else {
            if alertsList[section].alerts?.isEmpty ?? false {
                customModel.model = getEmptyModel(section: section)
                Router.shared.openEditMovoCashAlertsViewController(customModel: customModel, controller: controller!)
            } else {
                customModel.model = alertsList[section].alerts?[row]
                Router.shared.openEditMovoCashAlertsViewController(customModel: customModel, controller: controller!)
            }
        }
    }
    
    private func getEmptyModel(section: Int) -> AlertModel {
        
        var email = ""
        var phone = ""
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            email = profile.email
            phone = profile.cellPhoneNumber
        }
        
        let model = AlertModel(alertID: alertsList[section].alertID, alertTypeID: alertsList[section].alertTypeID, id: nil, operatorTypeID: CashAlertOperator.less.rawValue, amount: nil, sms: phone, email: email, mobilePush: false)
        return model
    }
}
