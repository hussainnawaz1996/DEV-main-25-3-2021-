//
//  HistoryTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sendToStaticLbl: UILabel!
    @IBOutlet weak var sendToLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var amountStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: PayHistoryModel) {
        let amount = model.amount ?? 0.0
        let absoluteAmount = abs(amount)

        sendToStaticLbl.text = model.label
        sendToLbl.text = model.payTo
        priceLbl.text = "$ \(absoluteAmount.numberFormatter(digitAfterPoint: 2))"
        statusLbl.text = model.status
        
        amountStatusLabel.text = amount > 0 ? "+" : "-"
        amountStatusLabel.textColor = amount > 0 ? Colors.GREEN_COLOR : Colors.RED_COLOR
    }
    
}
