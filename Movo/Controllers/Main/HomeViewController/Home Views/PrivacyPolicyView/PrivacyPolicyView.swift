//
//  PrivacyPolicyView.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class PrivacyPolicyView: UIView {
    
    @IBOutlet weak var customWebView: CustomWebView!
    var controller: UIViewController? = nil
    
    func configureView(controller: UIViewController) {
        self.controller = controller
    }
    
    func setup() {
        customWebView.configureView(str: WebUrls.privacyPolicy)
    }

}
