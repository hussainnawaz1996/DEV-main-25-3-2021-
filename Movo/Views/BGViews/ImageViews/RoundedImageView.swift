//
//  RoundedImageView.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit

class RoundedImageView: UIImageView {
    
    func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
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

