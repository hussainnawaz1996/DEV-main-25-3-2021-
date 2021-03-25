//
//  PersonalDetailViewController.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit

class PersonalDetailViewController: UIViewController {

    @IBOutlet var topButtons: [CircularSelectionButton]!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet var firstView: FirstView!

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topButtons.forEach { (button) in
            if button.tag == 0 {
                button.enable()
            } else {
                button.disable()
            }
        }
        
        view.addSubview(firstView)
        firstView.center = mainView.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstView.frame = mainView.frame
        firstView.center = mainView.center
    }
    
    //MARK:- IBActions
    @IBAction func topButtonWasPressed(_ sender: CircularSelectionButton) {
        topButtons.forEach { (button) in
            button.disable()
            if sender.tag == button.tag {
                sender.enable()
            }
        }
    }
    

}
