//
//  CreateTMCardTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class CreateTMCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var cardStatusIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: CardModel) {
        cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: model)
        
        let balanceDouble = Double(model.balance ?? "0.0") ?? 0.0
        balanceLbl.text = "$" + (balanceDouble.numberFormatter(digitAfterPoint: 2)) + "USD"
        
        let statusCode = model.statusCode ?? "F"
        if statusCode == CardStatusIcon.closed.rawValue || statusCode == CardStatusIcon.inActive.rawValue {
            cardStatusIcon.image = Icons.CARD_STATUS_FAILED_ICON
        } else {
            cardStatusIcon.image = Icons.CARD_STATUS_SUCCESS_ICON
        }
    }
    
}
