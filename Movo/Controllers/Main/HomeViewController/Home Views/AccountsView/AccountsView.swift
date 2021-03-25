//
//  AccountsView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit
import MCPSDK

class AccountsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var viewCardButtonTapped :(()->())?
    var controller: UIViewController? = nil
    
    private var isViewCardButtonTapped : Bool = false
    private var cardsList = [CardModel]()
    private var expandedList = [Bool]()
    private var refreshControl: UIRefreshControl?
    private var signinToken = ""
    private let entityId = "6088851347662650"
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.register(UINib(nibName: CardDetailViewCell.className, bundle: nil), forCellReuseIdentifier: CardDetailViewCell.className)
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
    
    //MARK:- UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardsList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = AccountsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 180))
        view.configureView(model: cardsList[section], showViewCardButton: self.expandedList[section] ? false : Common.shared.isPrimaryCard(model: cardsList[section]))
        
        view.viewCardButtonTapped = {
            if let index = self.cardsList.lastIndex(where: {Common.shared.isPrimaryCard(model: $0)}) {
//                self.openMovoSdk(referenceId: self.cardsList[index].referenceID ?? "")
                self.getSigninTokenAPICall(referenceId: self.cardsList[index].referenceID ?? "", entityId: self.entityId)
            }
//            let userInfo = [K.SECTION: 0, K.ROW:0]
//            NotificationCenter.default.post(name: .SIDE_MENU_OPTION_CLICKED, object: nil, userInfo: userInfo)
//
//            self.expandedList[section] = true
//            DispatchQueue.main.async {
//                self.tableView.reloadSections(IndexSet(section...section), with: UITableView.RowAnimation.automatic)
//            }
        }
        view.headerButtonTapped = {
            Router.shared.openTransactionHistoryViewController(selectedCard: self.cardsList[section], controller: self.controller!)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedList[section] ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardDetailViewCell.className, for: indexPath) as! CardDetailViewCell
        cell.configureCell(model: cardsList[indexPath.section])
        cell.hideCardButtonTapped = {
            self.expandedList[indexPath.section] = false
            DispatchQueue.main.async {
                let section = indexPath.section
                self.tableView.reloadSections(IndexSet(section...section), with: UITableView.RowAnimation.automatic)
            }
        }
        cell.cardNumberCopied = {
            DispatchQueue.main.async {
                Router.shared.openCopyOnClipboardPopupVC(controller: self.controller!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension AccountsView {
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
                        self.expandedList.removeAll()
                        self.cardsList.forEach { (model) in
//                            if Common.shared.isPrimaryCard(model: model) {
                                self.expandedList.append(false)
//                            }
                        }
                        
                        if let index = self.cardsList.lastIndex(where: {Common.shared.isPrimaryCard(model: $0)}) {
                            let model = self.cardsList[index]
                            self.cardsList.remove(at: index)
                            self.cardsList.insert(model, at: 0)
//                            self.getCardAuthData(referenceId: self.cardsList[index].referenceID ?? "")
                        }
                        
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
    
    private func getCardAuthData(referenceId:String) {
        
        showProgressOnView()
        
        let url = API.Card.getCardAuthData + "/\(referenceId)"
        HooleyAPIGeneric<GetCardAuthResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        if let index = self.cardsList.lastIndex(where: {Common.shared.isPrimaryCard(model: $0)}) {
                            self.cardsList[index].ccv = responseModel.data?.cvV2 ?? ""
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func openMovoSdk(referenceId: String, signinToken: String) {
        
        let config = UIConfiguration()
        config.backgroundColor = Colors.WHITE_COLOR
        config.navBarTextColor = Colors.WHITE_COLOR
        config.navBarBGColor = Colors.WHITE_COLOR
        config.loadingIndicatorColor = Colors.DARK_GREY
        config.loadingOption = LOAD_ON_SCREEN
        MCPSDKManager.setUIConfiguration(config)

        var params : [String:String] = [:]
        params["authToken"] = signinToken
        params["cardRefNo"] = referenceId
//        MCPSDKManager.preloadTaskList(params, mcpsdkCallback: nil)
        
        MCPSDKManager.startTask("revealCardInfo", delegate: self, params: params, parentVC: self.controller!, viewNavigationStyle: Alert, callBack: { (vc ) -> Void in
            // save vc reference at class level to use its reference later on.
            print("done movo sdk")
        })
    }
    
    private func getSigninTokenAPICall(referenceId: String, entityId: String) {
        let requestModel =  GetSigninTokenRequestModel(referenceID: referenceId, entityID: nil)

        
        showProgressOnView()
        HooleyPostAPIGeneric<GetSigninTokenRequestModel, GetSigninTokenResponseModel>.postRequest(apiURL: API.Card.getsignontoken, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.controller?.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.signinToken = responseModel.data?.signOnToken ?? ""
                        self.openMovoSdk(referenceId: referenceId, signinToken: self.signinToken)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}

extension AccountsView : MCPSDKCallBack {
    func onLoadingStarted() -> Bool {
        print("on loading started")
        return false
    }
    
    func onLoadingCompleted() {
        print("on loading completed")
    }
    
    func onSuccess(_ responsePayload: [AnyHashable : Any]!) {
        print(responsePayload)
    }
    
    func onError(_ errorCode: String!, errorDesc: String!) {
        print(errorCode)
        print(errorDesc)
    }
    
    func onCancel() {
        print("cancel")
    }
}
