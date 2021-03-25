//
//  TransferActivityDetailViewController.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class TransferActivityDetailViewController: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var transferIdLbl: UILabel!
    @IBOutlet weak var fromCardLbl: UILabel!
    @IBOutlet weak var toAccountLbl: UILabel!
    @IBOutlet weak var transferDateLbl: UILabel!
    
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


}
