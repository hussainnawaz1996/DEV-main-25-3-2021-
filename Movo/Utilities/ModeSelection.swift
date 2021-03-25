//
//  ViewSelection.swift
//  hooley
//
//  Created by Usama Sadiq on 2/19/18.
//  Copyright © 2018 messagemuse. All rights reserved.
//

import Foundation
import UIKit

class ModeSelection {
    static let instance = ModeSelection()

    func loginMode() -> Void {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let delegate = windowScene.delegate as? SceneDelegate {
                    if let window = delegate.window {
                        let rootVC = Storyboards.MAIN.instantiateViewController(withIdentifier: MainViewController.className) as! MainViewController
                        rootVC.setup(type: 1)
                        window.rootViewController = rootVC
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
    func signupMode() -> Void {
        if #available(iOS 13.0, *) {
            print(UIApplication.shared.connectedScenes.count)
            print(UIApplication.shared.connectedScenes)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let delegate = windowScene.delegate as? SceneDelegate {
                    if let window = delegate.window {
                        let rootVC = Storyboards.SIGNUP.instantiateViewController(withIdentifier: "SignUpNavigationController")
                        window.rootViewController = rootVC
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
}
