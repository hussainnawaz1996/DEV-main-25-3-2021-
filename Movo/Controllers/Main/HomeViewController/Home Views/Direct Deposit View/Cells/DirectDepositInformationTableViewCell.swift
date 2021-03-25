//
//  DirectDepositInformationTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class DirectDepositInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNumberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func confiugreCell() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            
            if let primaryCard = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                let customerId = primaryCard.customerID ?? ""
                if customerId.isEmpty == false {
                    if customerId.count > 13 {
                        let first3 = String(customerId.prefix(3))
                        let last10 = String(customerId.suffix(10))
                        
                        accountNumberLbl.text = first3 + last10
                    } else {
                        accountNumberLbl.text = "-"
                    }
                } else {
                    accountNumberLbl.text = "-"
                }
            }
        }
    }
}
