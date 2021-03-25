//
//  AddPayeeView.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class AddPayeeSearchTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    
    func configureCell(model:PayeeModel) {
        lbl.text = model.payeeName
    }
}

class AddPayeeView: UIView, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noDataIcon: UIImageView!
    @IBOutlet weak var searchView: UIView!
    
    private var searchPayeeArray = [PayeeModel]()
    private var refreshControl: UIRefreshControl?

    private var isLoading = false
    private var skipCount = 0
    private var takeCount = 20
    private var statesArray = [StateModel]()
    
    var controller: UIViewController? = nil
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.tableFooterView = UIView()
        searchView.addBorder(withBorderColor: #colorLiteral(red: 0.8352941176, green: 0.8666666667, blue: 0.8862745098, alpha: 1), borderWidth: 8.0)
        setupPullToRefresh()
    }

    func setup() {
        refreshControl?.endRefreshing()
        getStates()
    }
    
    @IBAction func searchButtonWasPressed(_ sender: UIButton) {
        resetArrays()
        performSearch()
        searchField.resignFirstResponder()
    }
    
    private func setupPullToRefresh() -> Void {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetArrays()
        performSearch()
        searchField.resignFirstResponder()
        return true
    }
    
    private func performSearch() {
        let str = searchField.text ?? ""
        if str.isEmpty {
            return
        }
        
        let requestModel = SearchPayeeRequestModel(searchString: str, skip: skipCount, take: takeCount)
        
        showProgressOnView()
        HooleyPostAPIGeneric<SearchPayeeRequestModel, GetSearchPayeeResponseModel>.postRequest(apiURL: API.ECheckbook.searchpayee, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.hideProgressFromView()
                
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.controller?.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        self.skipTakeImplementation(responseModel: responseModel)
                        self.noDataIcon.isHidden = self.searchPayeeArray.isEmpty ? false : true
                        self.tableView.isHidden = self.searchPayeeArray.isEmpty ? true : false
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    //MARK:- Helper Methods
    @objc func refresh(_ sender: Any) {
        resetArrays()
        performSearch()
    }
    
    private func resetArrays() {
        searchPayeeArray.removeAll()
        skipCount = 0
        isLoading = false
        session.cancelRequest(withURL: API.ECheckbook.searchpayee)
        tableView.reloadData()

    }
}

extension AddPayeeView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPayeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddPayeeSearchTableViewCell.className, for: indexPath) as! AddPayeeSearchTableViewCell
        cell.configureCell(model: searchPayeeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        let model = searchPayeeArray[indexPath.row]
        
        let customModel = CustomAddPayeeModel(selectedState: nil, payeeName: model.payeeName, payeeSerioulNumber: model.payeeSerialNo, payeeAddress: model.payeeAddress, isSearchFlow: true)
        Router.shared.openAddPayeeViewController(customModel:customModel, controller: controller!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            if !isLoading {
                self.isLoading = true
                self.skipCount += self.takeCount
                self.performSearch()
            }
        }
    }
    
    private func skipTakeImplementation(responseModel: GetSearchPayeeResponseModel) {
        let array = responseModel.data?.payees ?? []
        
        if self.searchPayeeArray.count > 0 && self.skipCount != 0 {
            for obj in array {
                self.searchPayeeArray.append(obj)
            }
        } else {
            self.searchPayeeArray = array
        }
        
        self.isLoading = array.count == 0
        self.tableView.reloadData()
        
    }
}


extension AddPayeeView {
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
