//
//  DirectDepositFundsTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class DirectDepositFundsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.roundedUIView(withRadius: 8.0, withBorderColor: Colors.GREY_COLOR, borderWidth: 0.7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
