//
//  AccountSummaryOrderPlasticCardTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class AccountSummaryOrderPlasticCardTableViewCell: UITableViewCell {

    @IBOutlet weak var button: BlackBGButton!
    var buttonTapped:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        button.configureView(font: Fonts.ALLER_BOLD_10!, radius: 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func orderPlasticCardButtonWasPressed(_ sender: BlackBGButton) {
        buttonTapped?()
    }
    
    
}
