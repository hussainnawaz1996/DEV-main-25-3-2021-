//
//  CircularSelectionButton.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit

class CircularSelectionButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        titleLabel?.font = Fonts.ALLER_BOLD_16!
        setTitleColor(Colors.BLACK, for: .normal)
        tintColor = Colors.BLACK
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.borderColor = Colors.BLACK.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func enable() {
        alpha = 1.0
    }
    
    func disable() {
        alpha = 0.3
    }
}

