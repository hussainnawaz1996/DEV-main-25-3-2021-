//
//  HistoryView.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountNumberLbl: UILabel!
    
    var controller: UIViewController? = nil
    @IBOutlet weak var balanceLbl: UILabel!
    
    private var historyArray = [PayHistoryModel]()
    private var selectedCard : CardModel?
    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: HistoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.className)
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
            self.setup()
        }
    }
    
    func setup() {
        refreshControl?.endRefreshing()
        setCardDetail()
        getHistory()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyArray.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//        view.configureView(str: historyArray[section].createdOn?.getHistoryDateStr() ?? "")
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = historyArray[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.createdOn ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = historyArray[section-1].createdOn ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
        
        let model = historyArray[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.createdOn ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = historyArray[section-1].createdOn ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.className, for: indexPath) as! HistoryTableViewCell
        cell.configureCell(model: historyArray[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
    @IBAction func cardButtonWasPressed(_ sender: UIButton) {
        Router.shared.openSelectAccountPopupVC(delegateView: self, isViewDelegate: true, isOnlyShowPrimaryAccounts: true, selectedCard: selectedCard, controller: self.controller!)
    }
    
    private func setCardDetail() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array = cardModel.cards?.filter({Common.shared.isPrimaryCard(model: $0)}) ?? []
            if let firstCard = array.first {
                selectedCard = firstCard
                let balanceDouble = Double(selectedCard?.balance ?? "0.0") ?? 0.0
                balanceLbl.text = "$" + (balanceDouble.numberFormatter(digitAfterPoint: 2)) + " USD"
                accountNumberLbl.text = Common.shared.getFormattedCardNumber(model: firstCard)

            }
        }
    }
        
}

extension HistoryView {
    private func getHistory() {
        showProgressOnView()
        
        let referenceId = selectedCard?.referenceID ?? ""
        let url = API.Card.payHistory + "/\(referenceId)"
        HooleyAPIGeneric<PayHistoryResponseModel>.fetchRequest(apiURL: url) { [weak self]
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
                        self.historyArray = responseModel.data ?? []
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

extension HistoryView : SelectAccountPopupVCDelegate {
    func getSelectedAccount(model: CardModel?) {
        selectedCard = model
        getHistory()
    }
}
