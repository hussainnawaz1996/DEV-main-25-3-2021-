//
//  TransactionHistoryViewController.swift
//  Movo
//
//  Created by Ahmad on 25/11/2020.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountStatusLabel: UILabel!

    func configureCell(model:Transaction) {
        let amount = Double(model.amount ?? "0.0") ?? 0.0
        let absoluteAmount = abs(amount)

        amountLbl.text = "$ \(absoluteAmount.numberFormatter(digitAfterPoint: 2))"
        descriptionLbl.text = model.transactionDescription
        
        amountStatusLabel.text = amount > 0 ? "+" : "-"
        amountStatusLabel.textColor = amount > 0 ? Colors.GREEN_COLOR : Colors.RED_COLOR
    }
}

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCard: CardModel?
    private var transactionList = [Transaction]()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.APP_COLOR
        tableView.register(UINib(nibName: AccountSummaryOrderPlasticCardTableViewCell.className, bundle: nil), forCellReuseIdentifier: AccountSummaryOrderPlasticCardTableViewCell.className)
        tableView.tableFooterView = UIView()
        getTransactionHistory()
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionList.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = transactionList[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.transDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = transactionList[section-1].transDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
            let lastMessageDate = previousDateStr.getDateStr()
            let currentMessageDate = dateStr.getDateStr()
            if lastMessageDate == currentMessageDate {
                return nil
            }else {
                return dateView
            }
        } else {
            return dateView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section < transactionList.count {
            
            let model = transactionList[section]
            let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            
            let dateStr = model.transDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
            dateView.configureView(str: dateStr.getHistoryDateStr())
            
            if section > 0 {
                let previousDateStr = transactionList[section-1].transDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
                let lastMessageDate = previousDateStr.getDateStr()
                let currentMessageDate = dateStr.getDateStr()
                if lastMessageDate == currentMessageDate {
                    return 0
                }else {
                    return 40
                }
            } else {
                return 40
            }
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < transactionList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionHistoryTableViewCell.className, for: indexPath) as! TransactionHistoryTableViewCell
            cell.configureCell(model: transactionList[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryOrderPlasticCardTableViewCell.className, for: indexPath) as! AccountSummaryOrderPlasticCardTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.buttonTapped = {
                Router.shared.openOrderPlasticCardPopupVC(controller: self)
            }
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < transactionList.count {
            return UITableView.automaticDimension
        } else {
            if let card = selectedCard {
                if Common.shared.isPrimaryCard(model: card){
                    return transactionList.count == 0 ? 0 : 85
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }

    private func getTransactionHistory() {
        showProgressHud()
        
        let referenceId = selectedCard?.referenceID ?? ""
        let url = API.Card.transactionHistory + "/\(referenceId)"
        HooleyAPIGeneric<TransactionHistoryResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.transactionList = responseModel.data?.statement?.transactions ?? []
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
