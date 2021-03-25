//
//  NavigationViewController.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import Foundation
import UIKit
import LGSideMenuController

class HomeNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.shadowImage = UIImage()
        
//        if let rootVC = self.rootViewController as? HomeViewController {
//            rootVC.addNotificationButton()
//        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
//    override var prefersStatusBarHidden : Bool {
//        return false
//    }
//    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .default
//    }
//    
//    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
//        return .fade
//    }
    
}
