//
//  ScheduledTransferReceiptViewController.swift
//  Movo
//
//  Created by Ahmad on 12/12/2020.
//

import UIKit

class ScheduledTransferReceiptViewController: UIViewController {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var transferIdLbl: UILabel!
    @IBOutlet weak var fromCardLbl: UILabel!
    @IBOutlet weak var toAccountLbl: UILabel!
    @IBOutlet weak var transferDateLbl: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var deleteButton: RedBGButton!
    var model: TransferModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let m = model {
            priceLbl.text = "$" + (m.amount ?? "")
            transferIdLbl.text = m.transferID
            if let profile = ProfileDetails.instance.getProfileDetails() {
                fromCardLbl.text = profile.lastName + " *" + Common.shared.getLast4Digits(str: m.transferFrom ?? "")
                toAccountLbl.text = profile.lastName + " *" + Common.shared.getLast4Digits(str: m.transferTo ?? "")
            }
            transferDateLbl.text = m.transferDate?.getHistoryDateStr()
            setStatus(status: m.status ?? "S")
        }
    }
    
    private func setStatus(status: String) {
        switch status {
        case TransferStatus.cancelled.rawValue:
            statusLbl.text = "Cancelled"
        case TransferStatus.deferred.rawValue:
            statusLbl.text = "Deferred"
        case TransferStatus.failed.rawValue:
            statusLbl.text = "Failed"
        case TransferStatus.inProgress.rawValue:
            statusLbl.text = "In Progress"
        case TransferStatus.logged.rawValue:
            statusLbl.text = "Logged"
        case TransferStatus.processed.rawValue:
            statusLbl.text = "Processed"
        case TransferStatus.scheduled.rawValue:
            statusLbl.text = "Scheduled"
        case TransferStatus.success.rawValue:
            statusLbl.text = "Success"
        default:
            break
        }
    }
    
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: UIButton) {
        Router.shared.openEditScheduleBankTransferViewController(model: model, controller: self)
    }
    
    @IBAction func deleteButtonWasPressed(_ sender: RedBGButton) {
        cancelTransfer(transferId: model?.transferID ?? "")
    }
    
}

extension ScheduledTransferReceiptViewController {
    
    private func cancelTransfer(transferId: String) {
        showProgressHud()
        
        let url = API.Banking.c2btransfercancel + "/\(transferId)"
        HooleyAPIGeneric<CardToBankTransferCancelResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
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
                            NotificationCenter.default.post(name: .REFRESH_SCHEDULED_TRANSFER_SCREEN, object: nil)
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
