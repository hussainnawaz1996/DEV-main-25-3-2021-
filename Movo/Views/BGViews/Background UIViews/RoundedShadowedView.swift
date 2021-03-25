//
//  RoundedShadowedView.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit


class RoundedShadowedView: UIView {
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMaxXMaxYCorner]
        } else {
            print("not able to round specific corner")
        }
        
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 15)
    }
}


class CircularView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        roundedUIView(withRadius: frame.height/2)
        clipsToBounds = true
    }
}

class RoundedPhotoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        roundedUIView(withRadius: 16)
        clipsToBounds = true
    }
}

class RoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        roundedUIView(withRadius: 5)
        clipsToBounds = true
    }
}

class SmallRoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        roundedUIView(withRadius: 2)
        clipsToBounds = true
    }
}
