//
//  PasscodeSettingsViewController.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class PasscodeSettingsViewController: UIViewController {

    @IBOutlet weak var passcodeField: UITextField!
    
    @IBOutlet weak var passcodeOnView: UIStackView!
    @IBOutlet weak var enterPasscodeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPasscodeView.isHidden = true
        passcodeOnView.isHidden = false
    }

    //MARK:- IBActions
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func turnPasscodeButtonWasPressed(_ sender: UIButton) {
        enterPasscodeView.isHidden = false
        passcodeOnView.isHidden = true
    }
}
