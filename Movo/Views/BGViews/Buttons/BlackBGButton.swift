//
//  BlackBGButton.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit

class BlackBGButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = 5
        clipsToBounds = true
        titleLabel?.font = Fonts.ALLER_BOLD_15!
        setTitleColor(Colors.WHITE, for: .normal)
        tintColor = Colors.WHITE
        backgroundColor = Colors.RED_COLOR
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func configureView(font:UIFont, radius:CGFloat) {
        layer.cornerRadius = radius
        titleLabel?.font = font
    }
}

class BlackBGRegularFontButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = 5
        clipsToBounds = true
        titleLabel?.font = Fonts.ALLER_REGULAR_15!
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        setTitleColor(Colors.WHITE, for: .normal)
        tintColor = Colors.WHITE
        backgroundColor = Colors.BLACK
        contentHorizontalAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func configureView(font:UIFont, radius:CGFloat) {
        layer.cornerRadius = radius
        titleLabel?.font = font
    }
}

class RedBGButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = 5
        clipsToBounds = true
        titleLabel?.font = Fonts.ALLER_BOLD_15!
        setTitleColor(Colors.WHITE, for: .normal)
        tintColor = Colors.WHITE
        backgroundColor = Colors.RED_COLOR
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func configureView(font:UIFont, radius:CGFloat) {
        layer.cornerRadius = radius
        titleLabel?.font = font
    }
}

class BlackBGNoFontButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = 2
        clipsToBounds = true
        setTitleColor(Colors.WHITE, for: .normal)
        tintColor = Colors.WHITE
        backgroundColor = Colors.BLACK
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

class GrayButton: UIButton {
    
    func setupView() {
        layer.cornerRadius = 2
        titleLabel?.font = Fonts.ALLER_BOLD_14!
        setTitleColor(Colors.BLACK, for: .normal)
        tintColor = Colors.BLACK
        backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.8666666667, blue: 0.8862745098, alpha: 1)
        layer.shadowColor = Colors.BLACK.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 0.7)
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
