//
//  SocialMediaView.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class SocialMediaView: UIView {

    @IBOutlet weak var customSwitchView: CustomSwitchView!
    
    var controller: UIViewController? = nil

    func configureView(controller: UIViewController) {
        self.controller = controller
        
        customSwitchView.switchValueWasChanged = { isSwitchOn in
            if isSwitchOn {
                SocialNetwork.Facebook.openPage()
            }
        }
    }

}
