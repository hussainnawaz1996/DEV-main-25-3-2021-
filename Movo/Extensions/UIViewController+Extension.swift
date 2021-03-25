//
//  UIViewController+Extension.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit
import MBProgressHUD
import AVFoundation
import MobileCoreServices
import AVKit

extension UIViewController {
    
    var topMostViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topMostViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topMostViewController ?? self
        default:
            return presentedViewController?.topMostViewController ?? self
        }
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
    func alertWithTwoOptions(title:String, alertMessage: String, buttonYesTitle: String, buttonCancelTitle: String, actionYes: @escaping (() -> Void), actionCancel: @escaping (() -> Void)) {
        
        DispatchQueue.main.async {
            self.hideProgressHud()
            
            let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: buttonYesTitle, style: UIAlertAction.Style.default, handler: {_ in
                actionYes()
            }))
            
            alert.addAction(UIAlertAction(title: buttonCancelTitle, style: UIAlertAction.Style.destructive, handler: {_ in
                actionCancel()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func alertMessage(title: String, alertMessage:String, action: (() -> Void)?)
    {
        if alertMessage.lowercased().contains("cancelled") || alertMessage.lowercased().contains("caused connection abort") || alertMessage.contains("The Internet connection appears to be offline."){
            return
        }
        
        DispatchQueue.main.async {
            self.hideProgressHud()
            let myAlert = UIAlertController(title:title, message:alertMessage, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                UIAlertAction in
                action?()
            }
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil)
        }
    }
    
    func addBackButtonOnly(){
        let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
        button.setImage(Icons.BACK_ARROW_BACK_ICON, for: UIControl.State.normal)
        button.contentMode = .left
        button.addTarget(self, action: #selector(backButtonPressed(btn:)), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 40)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: button.imageView!.image!.size.width / 2)
        button.contentHorizontalAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        if let navcontroller = self.navigationController{
            navcontroller.navigationItem.leftBarButtonItem = barButton
        }else{
            self.navigationItem.leftBarButtonItem = barButton
        }
    }
    
    @objc func backButtonPressed(btn:UIButton) {
        if let navController = navigationController {
            if navController.viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
            } else if isModal {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    
    func showProgressHud(title:String = K.LOADING_KEY) -> Void {
        let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
        progressHud.label.text = title
    }
    
    func hideProgressHud() -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view , animated: true)
        }
    }
  
    func openCountryPicker(completion: @escaping (String,String,String) -> Void) -> Void {
        let picker = ADCountryPicker(style: .grouped)
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "US"
        picker.alphabetScrollBarTintColor = Colors.BLACK
        picker.alphabetScrollBarBackgroundColor = UIColor.clear
        picker.closeButtonTintColor = Colors.BLACK
        picker.font = Fonts.HELVETICA_REGULAR_16
        picker.flagHeight = 40
        picker.hidesNavigationBarWhenPresentingSearch = false
        picker.searchBarBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            completion(name, code, dialCode)
        }
        self.navigationController?.pushViewController(picker, animated: true)
    }
    
    func openCameraWithPermision(type: cameraType = .image, isFront : Bool = false, delegateController:UIViewController) -> Void {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch (authStatus){
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        
                        DispatchQueue.main.async {
                            let imagePicker = UIImagePickerController()
                            imagePicker.delegate = delegateController.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                            imagePicker.allowsEditing = true
                            imagePicker.videoMaximumDuration = TimeInterval(20.0)
                            imagePicker.sourceType = .camera
                            if isFront {
                                imagePicker.cameraDevice = .front
                            } else {
                                imagePicker.cameraDevice = .rear
                            }
                            imagePicker.sourceType = UIImagePickerController.SourceType.camera
                            if type == .image {
                                imagePicker.mediaTypes = [kUTTypeImage as String]
                            } else {
                                imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String,kUTTypeVideo as String,kUTTypeAVIMovie as String,kUTTypeMPEG as String,kUTTypeMPEG4 as String]
                            }
                            imagePicker.modalPresentationStyle = .overFullScreen
                            delegateController.present(imagePicker, animated: true, completion: nil)
                        }
                        
                        
                    }
                }
            case .restricted:
                confirmationMessage(title: "Unable to access the Camera", message: Alerts.CAMERA_PRIVACY_SETTINGS_TEXT, buttonYesTitle: K.SETTINGS_TEXT, buttonCancelTitle: K.CANCEL_TEXT, actionYes: {
                    
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }) {
                }
            case .denied:
                confirmationMessage(title: "Unable to access the Camera", message: Alerts.CAMERA_PRIVACY_SETTINGS_TEXT, buttonYesTitle: K.SETTINGS_TEXT, buttonCancelTitle: K.CANCEL_TEXT, actionYes: {
                    
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }) {
                }
            case .authorized:
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = delegateController.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.allowsEditing = true
                imagePicker.videoMaximumDuration = TimeInterval(20.0)
                imagePicker.sourceType = .camera
                if isFront {
                    imagePicker.cameraDevice = .front
                } else {
                    imagePicker.cameraDevice = .rear
                }
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                if type == .image {
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                } else {
                    imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String,kUTTypeVideo as String,kUTTypeAVIMovie as String,kUTTypeMPEG as String,kUTTypeMPEG4 as String]
                }
                imagePicker.modalPresentationStyle = .overFullScreen
                delegateController.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            alertMessage(title: K.ALERT, alertMessage: Alerts.CAMERA_NOT_SUPPORTED_TEXT, action: {})
        }
    }
    
    func openShareSheet(text:String?,image:UIImage?,link:String?, controller:UIViewController?) -> Void {
        
        var shareAll = Array<Any>()
        if let message = text{
            shareAll.append(message)
        }
        if let img = image {
            shareAll.append(img)
        }
        if let lnk = link{
            if let url = NSURL(string: lnk){
                shareAll.append(url)
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            //            self.sharingDone(controller: controller)
        }
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    func confirmationMessage(title: String, message: String?,attributedMessage:NSAttributedString = NSAttributedString(string: ""), buttonYesTitle: String, buttonCancelTitle: String, hideCancelButton:Bool = false, actionYes: @escaping (() -> Void), actionCancel: @escaping (() -> Void)) {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: HooleyCustomAlertPopUPVC.className) as! HooleyCustomAlertPopUPVC
        control.titleString = title
        control.message = message
        control.attributedMessage = attributedMessage
        control.okButtonTitle = buttonYesTitle
        control.cancelButtonTitle = buttonCancelTitle
        control.hideCancelButton = hideCancelButton
        control.okAction = {
            actionYes()
        }
        
        control.cancelAction = {
            actionCancel()
        }
        self.present(control, animated: false, completion: nil)
        
    }
    
    func openVideoController(urlStr: String) {
        if let videoURL = URL(string: urlStr) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}
