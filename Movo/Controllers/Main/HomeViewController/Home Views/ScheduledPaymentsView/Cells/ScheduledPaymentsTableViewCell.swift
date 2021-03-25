//
//  ScheduledPaymentsTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 16/12/2020.
//

import UIKit

class ScheduledPaymentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var amountStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: BillPaymentModel) {
        
        let fromStr = Common.shared.getLast4Digits(str: model.payeeAccountNumber ?? "")
        let toStr = Common.shared.getLast4Digits(str: model.payeeAccountNumber ?? "")
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            fromLbl.text = "From: " + profile.lastName + " *" + fromStr
            toLbl.text = "To: " + profile.lastName + " *" + toStr
        }
        
        priceLbl.text = "\(model.amount ?? 0.0)".get2DigitDecimalString()
        amountStatusLabel.text = "-"
        amountStatusLabel.textColor = Colors.RED_COLOR
        
        setIcon(status: model.status ?? "S")
    }
    
    private func setIcon(status: String) {
        switch status {
        case PaymentStatus.failed.rawValue:
            typeIcon.image = Icons.TransferIcons.FAILED
        case PaymentStatus.failed.rawValue, PaymentStatus.Canceled.rawValue:
            typeIcon.image = Icons.TransferIcons.CANCELLED
        case PaymentStatus.sent.rawValue:
            typeIcon.image = Icons.TransferIcons.SUCCESS
        case PaymentStatus.inprogress.rawValue:
            typeIcon.image = Icons.TransferIcons.IN_PROGRESS
        default:
            typeIcon.image = Icons.TransferIcons.SCHEDULED
        }
    }
    
}
