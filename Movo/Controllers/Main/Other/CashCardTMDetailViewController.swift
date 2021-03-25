//
//  CashCardTMDetailViewController.swift
//  Movo
//
//  Created by Ahmad on 10/11/2020.
//

import UIKit
import MCPSDK

class CashCardTMDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var viewQRCodeButton: GrayButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var viewCardInfoTapped:(()->())?
    var copyNumberTapped:(()->())?
    var viewQRCodeTapped:(()->())?
    var transferCashCardTapped:(()->())?
    var reloadCashCardTapped:(()->())?
    
    func configureCell(selectedCard: CardModel?, isShowQR: Bool, isQRTapped : Bool) {
        let userName = (selectedCard?.firstName ?? "") + " " + (selectedCard?.lastName ?? "")

        cardView.configure(accountNumber: selectedCard?.cardNumber ?? "", expiry: selectedCard?.expiryDate ?? "", name: userName, cvv: selectedCard?.ccv)
        qrImageView.image = selectedCard?.cardNumber?.generateQRCode()
        
        qrImageView.isHidden = isShowQR ? false : true
        cardView.isHidden = isShowQR ? true : false
        topLabel.text = isShowQR ? "Ask your merchant to scan code" : "Enter card details manually to initiate the transactions"
        viewQRCodeButton.setTitle(isShowQR ? "Show My Card" : "View QR Code" , for: .normal)
        
        if isQRTapped {
            flip(isShowQR: isShowQR)
        }
        
        let str = "BY USING THE MOVO APP^{™} AND CARD YOU AGREE WITH THE TERMS AND CONDITIONS OF THE MOVO^{®} DIGITAL BANK ACCOUNT AND DEBIT MASTERCARD^{®} AGREEMENT AND FEE SCHEDULE. Banking services provided by Coastal Community Bank, Member FDIC. The MOVO^{®} Debit Mastercard^{®} is issued by Coastal Community Bank, Member FDIC, pursuant to license by Mastercard International."
        descriptionLbl.setAttributedTextWithSubscripts(str: str)
    }
    
    private func flip(isShowQR: Bool) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        if isShowQR {
            UIView.transition(with: cardView, duration: 0.5, options: transitionOptions, animations: {
                self.cardView.isHidden = true
            })
            
            UIView.transition(with: qrImageView, duration: 0.5, options: transitionOptions, animations: {
                self.qrImageView.isHidden = false
            })
        } else {
            UIView.transition(with: cardView, duration: 0.5, options: transitionOptions, animations: {
                self.cardView.isHidden = false
            })
            
            UIView.transition(with: qrImageView, duration: 0.5, options: transitionOptions, animations: {
                self.qrImageView.isHidden = true
            })
        }
        
    }
    
    @IBAction func viewCardInfoButtonWasPressed(_ sender: GrayButton) {
        viewCardInfoTapped?()
    }
    
    @IBAction func copyCardNumberWasPressed(_ sender: GrayButton) {
        copyNumberTapped?()
    }
    
    @IBAction func viewQRCodeWasPressed(_ sender: GrayButton) {
        viewQRCodeTapped?()
    }
    
    @IBAction func transferCashCardWasPressed(_ sender: GrayButton) {
        transferCashCardTapped?()
    }
    
    @IBAction func reloadCashCardWasPressed(_ sender: GrayButton) {
        reloadCashCardTapped?()
    }
    
}

class CashCardTMDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCard: CardModel?
    var primaryCard: CardModel?
    private var isShowQR = false
    private var isQRTapped = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLbl.setAttributedTextWithSubscripts(str: "CASH Card", superScript: "®")
        tableView.register(UINib(nibName: CashCardTMHeaderTableViewCell.className, bundle: nil), forCellReuseIdentifier: CashCardTMHeaderTableViewCell.className)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCardAccounts()
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .REFRESH_CASH_CARD_SCREEN, object: nil)
    }
    
    @IBAction func plusButtonWasPressed(_ sender: UIButton) {
        Router.shared.openCashCardTMEnterInfoViewController(selectedCard: selectedCard, controller: self)
    }
    
    //MARK:- UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CashCardTMHeaderTableViewCell.className, for: indexPath) as! CashCardTMHeaderTableViewCell
            if let card = selectedCard {
                cell.configureCell(model: card, isShowEditButton: true, isShowArrowIcon: false)
            }
            cell.editButtonTapped = {
                Router.shared.openCashCardEditNameViewController(selectedCard: self.selectedCard, controller: self)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CashCardTMDetailTableViewCell.className, for: indexPath) as! CashCardTMDetailTableViewCell
            cell.configureCell(selectedCard: selectedCard, isShowQR: isShowQR, isQRTapped: isQRTapped )
            
            cell.viewCardInfoTapped = {
                DispatchQueue.main.async {
                    self.getSigninTokenAPICall(referenceId: self.selectedCard?.referenceID ?? "", entityId: "")
                }
            }
            
            cell.copyNumberTapped = {
                let pasteboard = UIPasteboard.general
                if let model = self.selectedCard {
                    pasteboard.string = model.cardNumber
                }
//                self.view.showToast(message: "Card number copied!")
                DispatchQueue.main.async {
                    Router.shared.openCopyOnClipboardPopupVC(controller: self)
                }
                self.isQRTapped = false
            }
            
            cell.viewQRCodeTapped = {
                self.isShowQR = !self.isShowQR
                self.isQRTapped = true
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            cell.transferCashCardTapped = {
                
                self.isQRTapped = false
                
                let cashCardBalance = Double(self.selectedCard?.balance ?? "0.0") ?? 0.0
                if cashCardBalance == 0.0 {
                    self.alertMessage(title: K.ALERT, alertMessage: "You have insufficient balance to transfer", action: nil)
                } else {
                    Router.shared.openUnloadCashCardTMReceiptViewController(primaryCard: self.primaryCard, cashCard: self.selectedCard, controller: self)
                }
            }
            
            cell.reloadCashCardTapped = {
                
                self.isQRTapped = false
                Router.shared.openReloadCashCardTMViewController(primaryCard: self.primaryCard, cashCard: self.selectedCard, controller: self)
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        default:
            return 700
        }
    }
    
}


extension CashCardTMDetailViewController : SelectAccountPopupVCDelegate {
    func getSelectedAccount(model: CardModel?) {
        
    }
    
    private func getCardAuthData(referenceId:String) {
        
        showProgressHud()
        
        let url = API.Card.getCardAuthData + "/\(referenceId)"
        HooleyAPIGeneric<GetCardAuthResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        self.selectedCard?.ccv = responseModel.data?.cvV2 ?? ""
                        self.tableView.reloadData()
                        
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func getCardAccounts() {
        
        showProgressHud()
        
        let url = API.Card.getCardAccounts
        HooleyAPIGeneric<GetCardAccountsResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                       
                        let cards = responseModel.data?.cards ?? []
                        if let card = cards.filter({$0.referenceID == self.selectedCard?.referenceID ?? ""}).first {
                            self.selectedCard = card
                        }
                        
                        CardAccountModelInfoStruct.instance.saveData(model: responseModel.data)
                        
                        self.getCardAuthData(referenceId: self.selectedCard?.referenceID ?? "")
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

extension CashCardTMDetailViewController : MCPSDKCallBack {
    
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
        
        MCPSDKManager.startTask("revealCardInfo", delegate: self, params: params, parentVC: self, viewNavigationStyle: Alert, callBack: { (vc ) -> Void in
            // save vc reference at class level to use its reference later on.
            print("done movo sdk")
        })
    }
    
    private func getSigninTokenAPICall(referenceId: String, entityId: String) {
        
        let requestModel =  GetSigninTokenRequestModel(referenceID: referenceId, entityID: nil)
        
        showProgressHud()
        HooleyPostAPIGeneric<GetSigninTokenRequestModel, GetSigninTokenResponseModel>.postRequest(apiURL: API.Card.getsignontoken, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        let token = responseModel.data?.signOnToken ?? ""
                        self.openMovoSdk(referenceId: referenceId, signinToken: token)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
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
