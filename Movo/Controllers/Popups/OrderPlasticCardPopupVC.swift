//
//  OrderPlasticCardPopupVC.swift
//  Movo
//
//  Created by Ahmad on 03/12/2020.
//

import UIKit

class OrderPlasticCardPopupVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbl: UILabel!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            let shippingAddress = profile.shippingAddress1
            
            if shippingAddress.isEmpty {
                lbl.text = "Your Physical card will arrive within 7-10 business days. The card can only be sent to a home address at this time. Make sure to update your profile contact information first. If 10 business days have passed and you have not received your card, please contact MoPro Support."
            } else {
                lbl.text = "Your Physical card will arrive within 7-10 business days to \(shippingAddress). If 10 business days have passed and you have not received your card, please contact MoPro Support."
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.8)
            
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.8)
            
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.0)
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func btnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: BlackBGButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonWasPressed(_ sender: RedBGButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
