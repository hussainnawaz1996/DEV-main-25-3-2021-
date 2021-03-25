//
//  GreenBorderButton.swift
//  Movo
//
//  Created by Ahmad on 10/12/2020.
//

import UIKit

class GreenBorderButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        titleLabel?.font = Fonts.ALLER_BOLD_12!
        setTitleColor(Colors.GREEN_COLOR, for: .normal)
        tintColor = Colors.GREEN_COLOR
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.borderColor = Colors.GREEN_COLOR.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
