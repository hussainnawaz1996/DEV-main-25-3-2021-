//
//  CashCardTMView.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class CashCardTMView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cardsList = [CardModel]()
    private var primaryCardsArray = [CardModel]()
    private var secondaryCardsArray = [CardModel]()
    var controller: UIViewController? = nil
    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: CashCardTMHeaderTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashCardTMHeaderTableViewCell.className)
        tableView.register(UINib(nibName: CreateTMCardTableViewCell.className, bundle: nil), forCellReuseIdentifier: CreateTMCardTableViewCell.className)
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: .REFRESH_CASH_CARD_SCREEN, object: nil)
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
    
    func openCashCardEnterInfoScreen() {
        if let card = primaryCardsArray.first {
            Router.shared.openCashCardTMEnterInfoViewController(selectedCard: card, controller: controller!)
        }
    }
    
    //MARK:- UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return primaryCardsArray.count
        default:
            return secondaryCardsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CashCardTMHeaderTableViewCell.className, for: indexPath) as! CashCardTMHeaderTableViewCell
            cell.configureCell(model: primaryCardsArray[indexPath.row], isShowEditButton: false, isShowArrowIcon: true)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateTMCardTableViewCell.className, for: indexPath) as! CreateTMCardTableViewCell
            cell.configureCell(model: secondaryCardsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        switch indexPath.section {
        case 0:
            Router.shared.openSelectAccountPopupVC(delegateView: self, isViewDelegate: true, isOnlyShowPrimaryAccounts: true, selectedCard: self.primaryCardsArray.first, controller: controller!)
        default:
            Router.shared.openCashCardTMDetailViewController(selectedCard: secondaryCardsArray[indexPath.row], primaryCard: self.primaryCardsArray.first, controller: controller!)
        }
    }
    
}

extension CashCardTMView : SelectAccountPopupVCDelegate {
    
    func getSelectedAccount(model: CardModel?) {
        if let m = model {
            self.primaryCardsArray.removeAll()
            self.primaryCardsArray.append(m)
            self.tableView.reloadData()
        }
    }
    
    private func getCardAccounts() {
        
        showProgressOnView()
        
        let url = API.Card.getCardAccounts
        HooleyAPIGeneric<GetCardAccountsResponseModel>.fetchRequest(apiURL: url) { [weak self]
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
                        self.cardsList = responseModel.data?.cards ?? []
                        self.primaryCardsArray.removeAll()
                        if let primaryCard = self.cardsList.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                            self.primaryCardsArray.append(primaryCard)
                        }
                        self.secondaryCardsArray = self.cardsList.filter({Common.shared.isPrimaryCard(model: $0) == false })
                        CardAccountModelInfoStruct.instance.saveData(model: responseModel.data)
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
