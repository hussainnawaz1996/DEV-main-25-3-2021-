//
//  BiometricAuthenticationView.swift
//  Movo
//
//  Created by Ahmad on 10/11/2020.
//

import UIKit
import AuthenticationServices
import LocalAuthentication

class BiometricAuthenticationView: UIView {
    
    
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var customSwitchView: CustomSwitchView!
    var controller: UIViewController? = nil
    
    func configureView(controller: UIViewController) {
        self.controller = controller
                
        customSwitchView.switchValueWasChanged = { value in
            self.changePrivacy(isOn: value)
        }
    }
    
    func setup() {
        if Common.devicePasscodeSet() {
            toggleView.isHidden = false
            lbl.text = "Face ID/Touch ID allows you to log in more quickly and easily without having to manually enter a password.\nYou can turn Face ID/Touch ID On/Off at anytime. Please note that any Face ID/Touch ID registered on this device will have access to application.\nWe don't recommend using Face ID/Touch ID if you are sharing your device with someone else."
            
            if isBiometricLogin {
                customSwitchView.isSwitchOn = true
            } else {
                customSwitchView.isSwitchOn = false
            }
            
//            if let model = BiometricLoginInfoStruct.instance.fetchData() {
//                let biometricUsername = model.userName
//                if let profile = ProfileDetails.instance.getProfileDetails(){
//                    if biometricUsername == profile.userName {
//                        customSwitchView.isSwitchOn = true
//                    } else {
//                        customSwitchView.isSwitchOn = false
//                    }
//                }
//            } else {
//                customSwitchView.isSwitchOn = false
//            }
            
        } else {
            toggleView.isHidden = true
            lbl.text = "Touch/Face ID not available,\nGo to 'Settings -> Touch/Face ID & Passcode' and register at least one passcode"
        }
        
       
    }
    
    func changePrivacy(isOn: Bool) -> Void {
        authenticateUser(isOn: isOn)
    }
    
    func authenticateUser(isOn: Bool) {
        
        let context = LAContext()
        var error: NSError?
        
        
        if Common.devicePasscodeSet() {
            let reason = "Authenticate yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        if isOn {
                            var passwordStr = ""
                            if let userpass = Common.getUserPassword() {
                                passwordStr = userpass
                            }
                            if let profile = ProfileDetails.instance.getProfileDetails(){
                                let model = BiometricLoginModel(userName: profile.userName, password: passwordStr)
                                BiometricLoginInfoStruct.instance.saveData(model: model)
                            }
                        } else {
                            let model = BiometricLoginModel(userName: "", password: "")
                            BiometricLoginInfoStruct.instance.saveData(model: model)
                        }
                        UserDefaults.standard.setValue(isOn, forKey: UserDefaultKeys.iSBiometricLogin)
                    } else {
                        customSwitchView.isSwitchOn = !isOn
                        self.controller?.alertMessage(title: "Authentication failed", alertMessage: "Sorry!", action: nil)
                    }
                }
            }
        } else {
            self.controller?.alertMessage(title: "Touch/Face ID not available", alertMessage:  "Go to 'Settings -> Touch/Face ID & Passcode' and register at least one passcode", action: nil)
        }
    }
}
