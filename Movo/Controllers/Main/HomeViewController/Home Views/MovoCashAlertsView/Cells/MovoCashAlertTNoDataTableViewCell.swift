//
//  MovoCashAlertTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class MovoCashAlertTNoDataTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(description: String) {
        descriptionLbl.text = description
    }
    
}
