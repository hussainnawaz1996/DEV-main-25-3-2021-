//
//  PaymentHistoryDetailViewController.swift
//  Movo
//
//  Created by Ahmad on 08/11/2020.
//

import UIKit

class PaymentHistoryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
