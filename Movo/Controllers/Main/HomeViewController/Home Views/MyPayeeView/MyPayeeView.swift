//
//  MyPayeeView.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class MyPayeeTableViewCell: UITableViewCell {
    @IBOutlet weak var accountNumberLBl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var payButtonTapped:(()->())?
    
    func configureCell(model: PayeeModel) {
        let str = (model.payeeName ?? "") + " *" + Common.shared.getLast4Digits(str: model.payeeAccountNumber ?? "")
        accountNumberLBl.text = str
        let city = model.payeeCity ?? ""
        let state = model.payeeState ?? ""
        let country = "USA"
        let zip = model.payeeZip ?? ""
        detailLbl.text = city + ", " + state + ", " + country + ", " + zip
    }
    
    @IBAction func payButtonWasPressed(_ sender: UIButton) {
        payButtonTapped?()
    }
    
}

class MyPayeeView: UIView {

    @IBOutlet weak var noRecordView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: UIViewController? = nil
    
    private var payeesArray = [PayeeModel]()
    private var statesArray = [StateModel]()
    private var refreshControl: UIRefreshControl?

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: .REFRESH_MY_PAYEES_SCREEN, object: nil)
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
            self.getCardHolderPayeeList()
        }
    }

    func setup() {
        refreshControl?.endRefreshing()
        getCardHolderPayeeList()
        getStates()
    }
    
    @objc private func refreshScreen() {
        getCardHolderPayeeList()
    }
    
    func getCardHolderPayeeList() {
        showProgressOnView()
        
        let url = API.ECheckbook.getcardholderpayeelist
        HooleyAPIGeneric<GetCardHolderListResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                self.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.payeesArray = responseModel.data?.payees ?? []
                        self.noRecordView.isHidden = self.payeesArray.isEmpty ? false : true
                        self.tableView.isHidden = self.payeesArray.isEmpty ? true : false
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

extension MyPayeeView : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payeesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPayeeTableViewCell.className, for: indexPath) as! MyPayeeTableViewCell
        cell.configureCell(model: payeesArray[indexPath.row])
        cell.payButtonTapped = {
            Router.shared.openMakePaymentFromExistingPayeeViewController(selectedPayee: self.payeesArray[indexPath.row], controller: self.controller!)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = payeesArray[indexPath.row]
        
        var stateId = 0
        var stateIso2 = ""
        var selectedState : StateModel?
        if let index = statesArray.lastIndex(where: {$0.iso2 == model.payeeState}) {
            selectedState = statesArray[index]
            stateId = selectedState?.id ?? 0
            stateIso2 = selectedState?.iso2 ?? ""
        }
        let requestModel = AddPayeeRequestModel(srNo: model.payeeSerialNo, payeeName: model.payeeName, address: model.payeeAddress, city: model.payeeCity, stateID: stateId, stateIso2: stateIso2, zip: model.payeeZip, nickName: model.payeeNickname, depositAccountNumber: model.payeeAccountNumber)
         
        Router.shared.openPayeeReceiptViewController(requestModel: requestModel, selectedState: selectedState, controller: controller!)
    }
    
    private func getStates() -> Void {
        
        showProgressOnView()
        
        let url = API.Common.getstates + "/\(UnitedStatesId)"
        HooleyAPIGeneric<GetStatesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.statesArray = responseModel.data ?? []
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
