//
//  SignupSuccessfullViewController.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit

class SignupSuccessfullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonwasPressed(_ sender: BlackBGButton) {
        ModeSelection.instance.signupMode()
    }
    
}
