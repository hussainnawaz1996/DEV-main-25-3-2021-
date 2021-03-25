//
//  RadioButton.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import UIKit

class RadioButton: UIButton {
    
    func setupView() {
        titleLabel?.font = Fonts.ALLER_REGULAR_14!
        setTitleColor(Colors.BLACK, for: .normal)
        tintColor = Colors.BLACK
        isUserInteractionEnabled = true
        isEnabled = true
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
        setImage(Icons.RADIO_BUTTON_SELECTED, for: .normal)
    }
    
    func disable() {
        setImage(Icons.RADIO_BUTTON_UNSELECTED, for: .normal)
    }
}
