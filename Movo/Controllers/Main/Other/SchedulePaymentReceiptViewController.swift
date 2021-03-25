//
//  SchedulePaymentReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 18/12/2020.
//

import UIKit

class SchedulePaymentReceiptViewController: UIViewController {

    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var payeeNameLbl: UILabel!
    @IBOutlet weak var payeeAddressLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var paymentIdLbl: UILabel!
    @IBOutlet weak var fromCardLbl: UILabel!
    @IBOutlet weak var paymentDateLbl: UILabel!
    @IBOutlet weak var deliveredDateLbl: UILabel!
    @IBOutlet weak var cancelButton: RedBGButton!
    
    var requestModel : MakePaymentRequestModel?
    var customModel : CustomMakePaymentModel?
    
    var isEditFlow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = requestModel {
            let cardInfo = (customModel?.selectedCard?.programAbbreviation ?? "") + " *" +  Common.shared.getLast4Digits(str: customModel?.selectedCard?.cardNumber ?? "324234")
            
            priceLbl.text = "$" + (model.amount ?? "") + " USD"
            statusLbl.text = customModel?.selectedPayment?.status ?? ""
            payeeNameLbl.text = customModel?.selectedPayment?.payeeName ?? ""
            payeeAddressLbl.text = customModel?.selectedPayment?.payeeAddress ?? ""
            accountNumberLbl.text = model.payeeAccountNumber ?? ""
            paymentIdLbl.text = model.tansID
            fromCardLbl.text = cardInfo
            paymentDateLbl.text = model.paymentDate?.getHistoryDateStr()
            deliveredDateLbl.text = model.paymentDate?.getHistoryDateStr()
            
        }
        
        cancelButton.isHidden = isEditFlow ? false : true
        rightButtonView.isHidden = isEditFlow ? false : true
        titleLbl.text = isEditFlow ? "Schedule Payment" : "Payment History"
        subtitleLbl.isHidden = isEditFlow ? true : false
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func rightButtonWasPressed(_ sender: UIButton) {
        if isEditFlow {
            Router.shared.openEditSchedulePaymentViewController(paymentModel: customModel?.selectedPayment, selectedCard: customModel?.selectedCard, controller: self)
        } else {
            if let model = requestModel {
                
                showProgressHud()
                HooleyPostAPIGeneric<MakePaymentRequestModel, MakePaymentResponseModel>.postRequest(apiURL: API.ECheckbook.makePayment, requestModel: model) { [weak self] (result) in
                    guard let `self`  = self else { return }
                    DispatchQueue.main.async {
                        self.hideProgressHud()
                        switch result {
                        case .success(let responseModel):
                            
                            if responseModel.isError{
                                self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                            }else{
                                self.alertMessage(title: K.ALERT, alertMessage: responseModel.data?.responseDesc ?? "") {
                                    self.navigationController?.popToRootViewController(animated: true)
                                    
                                    var userInfo = [String: ReloadHomeModel]()
                                    let model = ReloadHomeModel(screen: ReloadHome.ScreeenName.makePayment, index: 0)
                                    userInfo = [ReloadHome.key : model]
                                    NotificationCenter.default.post(name: .RELOAD_HOME_SCREEN, object: nil, userInfo: userInfo)
                                }
                            }
                            
                        case .failure(let error):
                            let err = CustomError(description: (error as? CustomError)?.description ?? "")
                            self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: RedBGButton) {
        cancelTransfer(transferId: requestModel?.tansID ?? "")
    }
    
    private func cancelTransfer(transferId: String) {
        showProgressHud()
        
        let url = API.ECheckbook.cancelpayment + "/\(transferId)"
        HooleyAPIGeneric<MakePaymentResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.data?.responseDesc ?? "") {
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: .REFRESH_SCHEDULED_PAYMENT_SCREEN, object: nil)
                        }
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    

}
