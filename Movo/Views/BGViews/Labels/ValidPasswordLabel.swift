//
//  ValidPasswordLabel.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit

class ValidPasswordLabel: UILabel {
    
    func setupView() {
        
    }
    
    func enable() {
        self.textColor = Colors.GREEN_COLOR
    }
    
    func disable() {
        self.textColor = Colors.BLACK
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
