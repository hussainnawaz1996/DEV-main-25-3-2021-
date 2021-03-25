//
//  SetDateTimePopUPVC.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import UIKit

typealias DateSelectionCompletionHandler = ((Date?) -> ())

protocol SetDateTimePopUPDelegate: class {
    func doneButtonDidPressed(withDate date:Date?)
}

class SetDateTimePopUPVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var headingButton: UIButton!
    
    
    var doneButtonDidPressed:DateSelectionCompletionHandler?
    var alreadySelectedDate:Date?
    var minumumDate:Date?
    var maximumDate:Date?
    var isDateOnly:Bool = false
    var headingString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.datePicker.setValue(false, forKey: "highlightsToday");
        //datePicker.setValue(ThemeManager.shared.appTheme.subHeading, forKeyPath: "textColor")
        
        datePicker.datePickerMode = isDateOnly ? .date : .dateAndTime
        if let selectedDate = alreadySelectedDate {
            datePicker.date = selectedDate
        }
        
        if let date = minumumDate {
            datePicker.minimumDate = date
        }
        
        if let date = maximumDate {
            datePicker.maximumDate = date
        }
        
        headingButton.setTitle(headingString, for: UIControl.State.normal)
        popUpView.roundedUIView(withRadius: 10)
        
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .compact
//        }
        
        if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        self.view.bringSubviewToFront(self.datePicker)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.7)
            
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.7)
            
        }, completion: nil)
        addKeyboardListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.0)
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func viewWasTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        doneButtonDidPressed?(datePicker.date)
    }
    
    //MARK: --- keuboard delagte ---
    func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
