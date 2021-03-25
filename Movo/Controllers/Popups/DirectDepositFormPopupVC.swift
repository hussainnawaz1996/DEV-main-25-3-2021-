//
//  DirectDepositFormPopupVC.swift
//  Movo
//
//  Created by Ahmad on 05/12/2020.
//

import UIKit

class DirectDepositFormPopupVC: UIViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var amountCurrencyLabel: UILabel!
    
    
    private var depositEntirePaycheck = false
    private var amountCurrency = "$"
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.addBorder(withBorderColor: Colors.BLACK, borderWidth: 1.0)
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
    
    //MARK:- IBActions
    
    @IBAction func checkBoxButtonWasPressed(_ sender: UIButton) {
        depositEntirePaycheck = !depositEntirePaycheck
        checkBoxButton.setImage(depositEntirePaycheck ? Icons.CHECK_BOX_SELECTED : Icons.CHECK_BOX_UNSELECTED, for: .normal)
    }
    
    @IBAction func infoButtonWasPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func amountPickerButtonWasPressed(_ sender: UIButton) {
        let strArray = ["$", "%"]
        
        Router.shared.openDataPickerPopUpVC(content: strArray, title: "", selectedValue: amountCurrency, controller: self, dataPickedHandler: { (index, value) in
            DispatchQueue.main.async {
                self.amountCurrency = value
                self.amountCurrencyLabel.text = value
            }
        })
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension DirectDepositFormPopupVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
