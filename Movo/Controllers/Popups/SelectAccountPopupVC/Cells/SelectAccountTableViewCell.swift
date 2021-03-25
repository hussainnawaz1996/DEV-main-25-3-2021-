//
//  SelectAccountTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

class SelectAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var selectionIcon: UIImageView!
    
    func configureCell(cardModel: CardModel, isSelected: Bool) {
        accountNumberLbl.text = Common.shared.getFormattedCardNumber(model: cardModel)
        
        let balanceDouble = Double(cardModel.balance ?? "0.0") ?? 0.0
        balanceLbl.text = "Balance: $" + (balanceDouble.numberFormatter(digitAfterPoint: 2)) + "USD"
        selectionIcon.image = isSelected ? Icons.POPUP_SELECTION_ICON : Icons.POPUP_UNSELECTION_ICON
    }
    
}
