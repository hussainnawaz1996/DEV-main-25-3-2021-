//
//  CopyOnClipboardPopupVC.swift
//  Movo
//
//  Created by Ahmad on 09/01/2021.
//

import UIKit

class CopyOnClipboardPopupVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.roundedUIView(withRadius: 10.0)
        perform(#selector(dismissScreen), with: nil, afterDelay: 1.0)
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

    @IBAction func buttonWasPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}
