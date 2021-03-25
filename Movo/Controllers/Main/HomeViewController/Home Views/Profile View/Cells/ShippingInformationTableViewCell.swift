//
//  ShippingInformationTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 27/12/2020.
//

import UIKit

class ShippingInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var zipField: UITextField!
    
    var stateButtonTapped : (()->())?
    var addressChanged:((String)->())?
    var cityChanged:((String)->())?
    var zipChanged:((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func stateButtonWasPressed(_ sender: UIButton) {
        stateButtonTapped?()
    }
    
    func configureCell(address: String, city: String, zip:String, selectedState: StateModel?) {
        address1Field.text = address
        cityField.text = city
        stateButton.setTitle(selectedState == nil ? "-" : selectedState?.name, for: .normal)
        zipField.text = zip
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        let str = sender.text ?? ""
        if sender == address1Field {
            addressChanged?(str)
        } else if sender == cityField {
            cityChanged?(str)
        } else if sender == zipField {
            zipChanged?(str)
        }
    }
}
