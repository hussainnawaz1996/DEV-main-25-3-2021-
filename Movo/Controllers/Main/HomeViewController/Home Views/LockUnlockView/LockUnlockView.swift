//
//  LockUnlockView.swift
//  Movo
//
//  Created by Ahmad on 03/12/2020.
//

import UIKit

class LockUnlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var customSwitch: CustomSwitchView!
    
    var switchValueChanged:((Bool)->())?
    
    func configureCell(isEnabled: Bool, cardModel: CardModel) {
        accountNumberLbl.text = Common.shared.getFormattedCardNumber(model: cardModel)

        customSwitch.isSwitchOn = isEnabled
        customSwitch.switchValueWasChanged = { value in
            self.switchValueChanged?(value)
        }
    }
}

class LockUnlockView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    
    private var accountsArray = [CardModel]()
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.tableFooterView = UIView()
    }
    
    func setup() {
       getCardAccounts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockUnlockTableViewCell.className, for: indexPath) as! LockUnlockTableViewCell
        let model = accountsArray[indexPath.row]
        
        let statusCode = model.statusCode ?? "F"
        let isLocked = statusCode == CardStatusIcon.closed.rawValue || statusCode == CardStatusIcon.inActive.rawValue
        cell.configureCell(isEnabled: isLocked, cardModel: accountsArray[indexPath.row])
        cell.switchValueChanged = { value in
            DispatchQueue.main.async {
                let referenceId = self.accountsArray.first?.referenceID ?? ""
                self.lockUnlockAPI(referenceId: referenceId, isBlock: value)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

}

extension LockUnlockView {
    private func lockUnlockAPI(referenceId: String, isBlock: Bool) {
        showProgressOnView()
        
        let url = API.Card.setcardstatus + "/\(referenceId)" + "/\(isBlock)"
        HooleyAPIGeneric<SetCardStatusResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self` = self else { return }
            self.hideProgressFromView()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        let str = isBlock ? "Card Locked" :  "Card Unlocked"
                        
                        self.controller?.alertMessage(title: K.SUCCESS, alertMessage: str) {
                            self.getCardAccounts()
                        }
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
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
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages)
                    }else{
                        let array = responseModel.data?.cards ?? []
                        
                        self.accountsArray.removeAll()
                        
                        if let index = array.lastIndex(where: {Common.shared.isPrimaryCard(model: $0)}) {
                            let model = array[index]
                            self.accountsArray.append(model)
                        }
                        self.tableView.reloadData()
                        CardAccountModelInfoStruct.instance.saveData(model: responseModel.data)
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
