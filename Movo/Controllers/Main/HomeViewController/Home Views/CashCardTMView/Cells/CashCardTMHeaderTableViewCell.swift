//
//  CashCardTMHeaderTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 29/11/2020.
//

import UIKit

class CashCardTMHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var availableBalanceLbl: UILabel!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var editButtonTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: CardModel, isShowEditButton: Bool, isShowArrowIcon: Bool) {
        cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: model)

        let balanceDouble = Double(model.balance ?? "0.0") ?? 0.0
        availableBalanceLbl.text = "$" + (balanceDouble.numberFormatter(digitAfterPoint: 2)) + "USD"
        pencilButton.isHidden = isShowEditButton ? false : true
        arrowIcon.isHidden = isShowArrowIcon ? false : true
    }
    
    @IBAction func editButtonWasPressed(_ sender: UIButton) {
        editButtonTapped?()
    }
}
