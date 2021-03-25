//
//  AccountsSummaryView.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class AccountSummaryView : UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var expandedList = [Bool]()
    private let headerArray = ["Recent Deposits", "Recent Transactions"]
    private var transactionList = [TransactionModel]()
    private var depositList = [TransactionModel]()
    var controller: UIViewController? = nil

    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller

        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: AccountSummaryNoTransactionTableViewCell.className, bundle: nil), forCellReuseIdentifier: AccountSummaryNoTransactionTableViewCell.className)
        
        tableView.register(UINib(nibName: AccountSummaryTransactionTableViewCell.className, bundle: nil), forCellReuseIdentifier: AccountSummaryTransactionTableViewCell.className)
        
        tableView.register(UINib(nibName: AccountSummaryOrderPlasticCardTableViewCell.className, bundle: nil), forCellReuseIdentifier: AccountSummaryOrderPlasticCardTableViewCell.className)
        
        
        for _ in 0...2 {
            expandedList.append(true)
        }
        tableView.tableFooterView = UIView()
        setupPullToRefresh()
    }

    private func setupPullToRefresh() -> Void {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.getMiniStatementMultiAccounts()
        }
    }
    
    func setupView() {
        refreshControl?.endRefreshing()
        getMiniStatementMultiAccounts()
    }
    
    //MARK: UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let view = AccountsSummaryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            switch section {
            case 0:
                view.configureView(str: "Recent Deposits", isExpanded: expandedList[section], isShowViewAllButton: false)
            case 1:
                view.configureView(str: "Recent Transactions", isExpanded: expandedList[section], isShowViewAllButton: true)
            default:
                break
            }
            
            view.headerBtnTapped = {
                self.expandedList[section] = !self.expandedList[section]
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(section...section), with: UITableView.RowAnimation.automatic)
                }
            }
            
            return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if expandedList[section] {
                return depositList.count == 0 ? 1 : depositList.count
            } else {
                return 0
            }
        case 1:
            if expandedList[section] {
                return transactionList.count == 0 ? 1 : transactionList.count
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 85
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.depositList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryNoTransactionTableViewCell.className, for: indexPath) as! AccountSummaryNoTransactionTableViewCell
                return cell
               
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTransactionTableViewCell.className, for: indexPath) as! AccountSummaryTransactionTableViewCell
                cell.configureCell(model: depositList[indexPath.row])
                return cell
            }
        case 1:
            if self.transactionList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryNoTransactionTableViewCell.className, for: indexPath) as! AccountSummaryNoTransactionTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTransactionTableViewCell.className, for: indexPath) as! AccountSummaryTransactionTableViewCell
                cell.configureCell(model: transactionList[indexPath.row])
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryOrderPlasticCardTableViewCell.className, for: indexPath) as! AccountSummaryOrderPlasticCardTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.buttonTapped = {
                Router.shared.openOrderPlasticCardPopupVC(controller: self.controller!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
}

extension AccountSummaryView {
    private func getMiniStatementMultiAccounts() {
        
        showProgressOnView()
        
        let url = API.Card.miniStatementMultiAccounts
        HooleyAPIGeneric<GetMiniStatementResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressFromView()
                self.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.transactionList = responseModel.data?.statement?.transactions ?? []
                        self.depositList = self.transactionList.filter({($0.amount ?? 0) > 0})
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
