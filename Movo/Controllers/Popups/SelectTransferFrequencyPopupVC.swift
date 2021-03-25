//
//  SelectTransferFrequencyPopupVC.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

protocol SelectTransferFrequencyPopupVCDelegate: class {
    func getSelectedFrequency(frequency: FrequencyType)
}

class SelectTransferFrequencyPopupVC: UIViewController {
    @IBOutlet weak var bgView: UIView!

    var delegate: SelectTransferFrequencyPopupVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @IBAction func rightNowButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.getSelectedFrequency(frequency: FrequencyType.once)
        }
    }
    
    @IBAction func specificDateButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.getSelectedFrequency(frequency: FrequencyType.date)
        }
    }
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
