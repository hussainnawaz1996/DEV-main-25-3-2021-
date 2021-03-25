//
//  TransferActivityView.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class TransferActivityView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataFoundView: UIStackView!
    
    private var transferList = [TransferModel]()
    private var refreshControl: UIRefreshControl?

    var controller: UIViewController? = nil
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: TransferActivityTableViewCell.className, bundle: nil), forCellReuseIdentifier: TransferActivityTableViewCell.className)
        tableView.tableFooterView = UIView()
        setupPullToRefresh()

    }

    func setup() {
        refreshControl?.endRefreshing()
        getCardToBankTransferList()
    }
    
    private func setupPullToRefresh() -> Void {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.getCardToBankTransferList()
        }
    }
    
}

extension TransferActivityView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transferList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = transferList[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.transferDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = transferList[section-1].transferDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
        
        let model = transferList[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.transferDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = transferList[section-1].transferDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransferActivityTableViewCell.className, for: indexPath) as! TransferActivityTableViewCell
        cell.configureCell(model: transferList[indexPath.section])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        Router.shared.openTransferActivityDetailViewController(model: transferList[indexPath.section], controller: self.controller!)
    }
}

extension TransferActivityView {
    private func getCardToBankTransferList() -> Void {
        
        showProgressOnView()
        
        let url = API.Banking.c2btransferlist
        HooleyAPIGeneric<CashToBankTransferListResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                self.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        let list = responseModel.data?.singleTransfers ?? []
                        self.transferList = list.filter({$0.status == TransferStatus.failed.rawValue || $0.status == TransferStatus.processed.rawValue || $0.status == TransferStatus.cancelled.rawValue})
                        self.noDataFoundView.isHidden = self.transferList.count == 0 ? false : true
                        self.tableView.isHidden = self.transferList.count == 0 ? true : false
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
