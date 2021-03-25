//
//  UIView+Extension.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit
import MBProgressHUD

extension UIView {
    func roundWithCorners(corners:CACornerMask, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            print("not able to round specific corner")
        }
    }
    
    func simpleRound(){
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
    
    func roundedUIView(withRadius radius: CGFloat){
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func roundedUIView(withRadius radius: CGFloat,withBorderColor color:UIColor,borderWidth:CGFloat = 1){
        layer.cornerRadius = radius
        clipsToBounds = true
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }
    
    func addBorder(withBorderColor color:UIColor,borderWidth:CGFloat = 1){
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }
    
    func showProgressOnView(title:String = K.LOADING_KEY) -> Void {
        let progressHud = MBProgressHUD.showAdded(to: self, animated: true)
        progressHud.label.text = title
    }
    
    func hideProgressFromView() -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self , animated: true)
        }
    }
    
    func snapshot(withBlur: Bool) -> UIImage {
        if withBlur {
            // MARK: With Blur View
            snapshotView(afterScreenUpdates: true)
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        } else {
            // MARK: Without Blur View
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    }
    
    func showToast(message : String, font: UIFont = .systemFont(ofSize: 12.0)) {
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.frame.size.height-100, width: self.frame.width - 20, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 1, delay: 1.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
