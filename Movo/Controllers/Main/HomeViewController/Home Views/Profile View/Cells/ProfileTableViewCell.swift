//
//  ProfileTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var headerField: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(headerStr: String, detailStr: String, placeholder: String) {
        headerField.text = headerStr
        detailTextField.text = detailStr
        detailTextField.placeholder = placeholder
    }
    
}
