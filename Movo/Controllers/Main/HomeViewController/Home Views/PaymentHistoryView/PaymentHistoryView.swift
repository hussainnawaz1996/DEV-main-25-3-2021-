//
//  PaymentHistoryView.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class PaymentHistoryView: UIView {
    @IBOutlet weak var noDataView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private var billPaymentList = [BillPaymentModel]()
    var controller: UIViewController? = nil
    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: ScheduledPaymentsTableViewCell.className, bundle: nil), forCellReuseIdentifier: ScheduledPaymentsTableViewCell.className)
        
        tableView.tableFooterView = UIView()
        setupPullToRefresh()
    }
    
    func setup() {
        refreshControl?.endRefreshing()
        getBillPaymentHistory()
    }
    
    private func setupPullToRefresh() -> Void {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.getBillPaymentHistory()
        }
    }
}

extension PaymentHistoryView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return billPaymentList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = billPaymentList[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.scheduledDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = billPaymentList[section-1].scheduledDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
        
        let model = billPaymentList[section]
        let dateView = HistoryHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let dateStr = model.scheduledDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
        dateView.configureView(str: dateStr.getHistoryDateStr())
        
        if section > 0 {
            let previousDateStr = billPaymentList[section-1].scheduledDate ?? Date().convertTimeToUTC().getOriginalLocalDate().getZeroTimeOnlyDateString()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledPaymentsTableViewCell.className, for: indexPath) as! ScheduledPaymentsTableViewCell
        cell.configureCell(model: billPaymentList[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        let model = billPaymentList[indexPath.row]
        let amountStr = model.amount?.numberFormatter(digitAfterPoint: 2)
        var selectedCard : CardModel?
        
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            if let card = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                selectedCard = card
            }
        }
        let customModel = CustomMakePaymentModel(payeeName: model.payeeName, selectedPayment: model, selectedCard: selectedCard)

        let requestModel = MakePaymentRequestModel(tansID: model.billPaymentTransID, payeeSrNo: model.payeeSerialNo, payeeAccountNumber: model.payeeAccountNumber, amount: amountStr, paymentDate: model.scheduledDate, comments: "")
        Router.shared.openSchedulePaymentReceiptViewController(requestModel: requestModel, customModel: customModel, isEditFlow: false, controller: controller!)
    }
    
}

extension PaymentHistoryView {
    private func getBillPaymentHistory() -> Void {
        
        showProgressOnView()
        
        let url = API.ECheckbook.getbillpaymenthistory
        HooleyAPIGeneric<GetBillPaymentHistoryResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            
            DispatchQueue.main.async {
                self.hideProgressFromView()
                self.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        let list = responseModel.data?.transactions ?? []
                        self.billPaymentList = list.filter({$0.status == PaymentStatus.failed.rawValue || $0.status == PaymentStatus.posted.rawValue || $0.status == PaymentStatus.sent.rawValue || $0.status == PaymentStatus.Canceled.rawValue})
                        self.noDataView.isHidden = self.billPaymentList.count == 0 ? false : true
                        self.tableView.isHidden = self.billPaymentList.count == 0 ? true : false
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
