//
//  MyBankAccountsView.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class MyBankAccountsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBanksIcon: UIImageView!
    private var accountsList = [AccountModel]()
    
    var controller: UIViewController? = nil
    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: MyBankAccountsTableViewCell.className, bundle: nil), forCellReuseIdentifier: MyBankAccountsTableViewCell.className)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: .REFRESH_MY_BANK_ACCOUNT_SCREEN, object: nil)
        setupPullToRefresh()
        tableView.tableFooterView = UIView()

    }
    
    private func setupPullToRefresh() -> Void {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.getCardAccounts()
        }
    }

    func setup() {
        refreshControl?.endRefreshing()
        getCardAccounts()
    }
    
    @objc private func refreshScreen() {
        getCardAccounts()
    }
    
    private func getCardAccounts() {
        
        showProgressOnView()
        
        let url = API.Banking.bankaccountslist
        HooleyAPIGeneric<MyBankAccountsResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressFromView()
                self.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    } else {
                        self.accountsList = responseModel.data?.accounts ?? []
                        self.noBanksIcon.isHidden = self.accountsList.isEmpty ? false : true
                        self.tableView.isHidden = self.accountsList.isEmpty ? true : false

                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    //MARK:- UITableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBankAccountsTableViewCell.className, for: indexPath) as! MyBankAccountsTableViewCell
        cell.configureCell(model: accountsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        
        var legalName = ""

        if let profile = ProfileDetails.instance.getProfileDetails() {
            legalName = profile.firstName + " " + profile.lastName
        }
        
        let model = accountsList[indexPath.row]
        
        let requestModel = CreateBankAccountRequestModel(bankSerialNumberIfEdit: model.accountSrNo, accountType: AccountType.cardToBank.rawValue, legalName: legalName, bankName: model.bankName, routingNumber: model.routingNumber, isCheckingAccount: model.accountTypeSpecified, bankAccountNumber: model.accountNumber, nickName: model.accountNickname, comments: model.comments)
        
        Router.shared.openBankAccountReceiptViewController(requestModel: requestModel, controller: controller!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
