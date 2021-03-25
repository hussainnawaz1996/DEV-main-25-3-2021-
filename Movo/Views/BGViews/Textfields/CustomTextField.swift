//
//  CustomTextField.swift
//  Movo
//
//  Created by Ahmad on 13/02/2021.
//

import UIKit

class CustomTextField: UITextField {
    
    private var leftImageView:UIImageView?
    private var rightButtonView:UIButton?
        
    var leftImage:UIImage? {
        didSet {
            if let image = leftImage {
                
                leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
                leftImageView?.image = image
                leftImageView?.contentMode = .center
                leftImageView?.tintColor = text!.isEmpty ? Colors.WHITE  : Colors.WHITE
                
                let view = UIView(frame: CGRect(x: 2, y: 0, width: 40, height: 40))
                view.addSubview(leftImageView!)
                leftViewMode = UITextField.ViewMode.always
                leftView = view
                leftImageView!.center = view.center
            } else {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
                leftViewMode = UITextField.ViewMode.always
                leftView = view
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        textColor = Colors.WHITE
        placeholderColor(Colors.WHITE )
        
        autocorrectionType = .yes
        borderStyle = .none
        layer.borderColor = Colors.WHITE.cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 4
        font = Fonts.ALLER_REGULAR_14
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.21)
        autocapitalizationType = .sentences
        
        leftImage = nil
    }
}
