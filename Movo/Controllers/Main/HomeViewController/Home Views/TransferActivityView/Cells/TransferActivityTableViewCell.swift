//
//  TransferActivityTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class TransferActivityTableViewCell: UITableViewCell {


    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var amountStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: TransferModel) {
        
        let fromStr = Common.shared.getLast4Digits(str: model.transferFrom ?? "")
        let toStr = Common.shared.getLast4Digits(str: model.transferTo ?? "")
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            fromLbl.text = "From: " + profile.lastName + " *" + fromStr
            toLbl.text = "To: " + profile.lastName + " *" + toStr
        }
        
        priceLbl.text = model.amount?.get2DigitDecimalString() ?? "0.00"
        amountStatusLabel.text = "-"
        amountStatusLabel.textColor = Colors.RED_COLOR
        
        setIcon(status: model.status ?? "S")
    }
    
    private func setIcon(status: String) {
        switch status {
        case TransferStatus.failed.rawValue:
            typeIcon.image = Icons.TransferIcons.FAILED
        case TransferStatus.cancelled.rawValue:
            typeIcon.image = Icons.TransferIcons.CANCELLED
        case TransferStatus.processed.rawValue, TransferStatus.success.rawValue:
            typeIcon.image = Icons.TransferIcons.SUCCESS
        case TransferStatus.inProgress.rawValue:
            typeIcon.image = Icons.TransferIcons.IN_PROGRESS
        default:
            typeIcon.image = Icons.TransferIcons.SCHEDULED
        }
    }
    
}
