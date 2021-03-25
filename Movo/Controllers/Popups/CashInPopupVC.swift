//
//  CashInPopupVC.swift
//  Movo
//
//  Created by Ahmad on 05/12/2020.
//

import UIKit

protocol CashInPopupVCDelegate: class {
    func cashInPopupButtonTapped(isGreeDotReload: Bool, isGreenDotMoneyPack: Bool, visaReadyLink: Bool)
}

class CashInPopupVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var delegate:CashInPopupVCDelegate?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.roundedUIView(withRadius: 10.0)
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
    
    @IBAction func greenDotReloadButtonWasPressed(_ sender: BlackBGRegularFontButton) {
        dismiss(animated: true) {
            self.delegate?.cashInPopupButtonTapped(isGreeDotReload: true, isGreenDotMoneyPack: false, visaReadyLink: false)
        }
    }
    
    @IBAction func greenDotMoneypackButtonWasPressed(_ sender: BlackBGRegularFontButton) {
        dismiss(animated: true) {
            self.delegate?.cashInPopupButtonTapped(isGreeDotReload: false, isGreenDotMoneyPack: true, visaReadyLink: false)
        }
    }
    
    @IBAction func visaReadylinkButtonWasPressed(_ sender: BlackBGRegularFontButton) {
        dismiss(animated: true) {
            self.delegate?.cashInPopupButtonTapped(isGreeDotReload: false, isGreenDotMoneyPack: false, visaReadyLink: true)
        }
    }
    
}
