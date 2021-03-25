//
//  MovoCashAlertsAddedInformationTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 31/12/2020.
//

import UIKit

class MovoCashAlertsAddedInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var pushNotificationView: UIView!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var smsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: AlertModel, isOperator: Bool) {
        
        let email = model.email ?? ""
        let phone = model.sms ?? ""
        let push = model.mobilePush ?? false
        
        emailView.isHidden = email.isEmpty ? true : false
        phoneView.isHidden = phone.isEmpty ? true : false
        pushNotificationView.isHidden = push ? false : true
        
        emailLbl.text = email
        smsLbl.text = phone
        
        if isOperator {
            showDesciption(model: model)
        } else {
            descriptionView.isHidden = true
        }
    }
    
    private func showDesciption(model: AlertModel) {
        var operatorStr = ""
        
        if model.operatorTypeID == CashAlertOperator.greater.rawValue {
            descriptionView.isHidden = false
            operatorStr = "Greater than or equals"
            
            descriptionLbl.text = "When an amount is " + operatorStr + " to $\(model.amount ?? 0.0) USD " + "is deducted from this account"
        } else if model.operatorTypeID == CashAlertOperator.less.rawValue {
            descriptionView.isHidden = false
            operatorStr = "Less than or equals"
            
            descriptionLbl.text = "When an amount is " + operatorStr + " to $\(model.amount ?? 0.0) USD " + "is deducted from this account"
        } else {
            descriptionView.isHidden = true
        }
    }
}
