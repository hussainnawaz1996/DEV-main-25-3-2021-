//
//  SignUpNavigationController.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit

class SignUpNavigationController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {

    var isPushingViewController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.shadowImage = UIImage()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
//    override var prefersStatusBarHidden : Bool {
////        return UIApplication.shared.statusBarOrientation.isLandscape && UI_USER_INTERFACE_IDIOM() == .phone
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

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushingViewController = false
    }
}
