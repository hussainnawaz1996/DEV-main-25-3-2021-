//
//  HooleyCustomAlertPopUPVC.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit

class HooleyCustomAlertPopUPVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popUpMainView: UIView!
    @IBOutlet weak var infoDetailLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var titleString:String = ""
    var message:String?
    var attributedMessage = NSAttributedString.init(string: "")
    var cancelButtonTitle:String = "Cancel"
    var okButtonTitle:String = "Ok"
    var hideCancelButton:Bool = true
    var okAction:(() -> Void)?
    var cancelAction:(() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        if let message = message {
            infoDetailLabel.text = message
        }else{
            infoDetailLabel.attributedText = attributedMessage
        }
       
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        okButton.layer.cornerRadius = okButton.frame.height / 2
        cancelButton.isHidden = hideCancelButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        popUpMainView.layer.cornerRadius = 15
        popUpMainView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        popUpMainView.layer.shadowRadius = 5
        popUpMainView.layer.shadowOpacity = 0.5
        popUpMainView.backgroundColor = Colors.WHITE
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.7)
            
        }, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.0)
        }, completion: nil)
    }
    
    @IBAction func okButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true) {
             self.okAction?()
        }
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.cancelAction?()
        }
    }
}
