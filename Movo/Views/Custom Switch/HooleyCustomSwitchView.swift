//
//  HooleyCustomSwitchView.swift
//  CustomSwitch
//
//  Created by Macbook Pro 1 on 4/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

class CustomSwitchView: UIView {
    
    @IBOutlet var thumbView: UIView!
    @IBOutlet var baseView: UIView!
    
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet var switchButton: UIButton!
    
    private var view: UIView!

    var isSwitchOn:Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.leftConstraint.constant = self.isSwitchOn ? 21 : 1
                self.rightConstraint.constant = self.isSwitchOn ? 1 : 21
                self.thumbView.backgroundColor = self.isSwitchOn ? Colors.BLACK : Colors.WHITE
            }
        }
    }
    
    var switchValueWasChanged:((Bool)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        configureView()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    private func configureView() -> Void {
        view.layer.cornerRadius = view.frame.height/2
        view.backgroundColor = UIColor.clear
        baseView.layer.cornerRadius = baseView.frame.height/2
        baseView.backgroundColor = Colors.LIGHT_GREY
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        isSwitchOn = false
    }
    
    @IBAction func switchButtonWasPressed(_ sender: UIButton) {
        isSwitchOn = !isSwitchOn
        switchValueWasChanged?(isSwitchOn)
    }
}
