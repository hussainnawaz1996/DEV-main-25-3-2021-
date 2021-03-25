//
//  WhiteBorderedTextfield.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit

class WhiteBorderedTextfield: UITextField,UITextFieldDelegate {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    private var leftImageView:UIImageView?
    private var rightButtonView:UIButton?
    
    var textChanged : ((String)->())?
    var deleteText : EmptyCompletionHandler?

    var rightButtonPressed : EmptyCompletionHandler?
    
    var isRightButtonPressed : Bool = false {
        didSet {
            rightButtonView?.tintColor = isRightButtonPressed ? Colors.BLACK : Colors.BLACK
            isSecureTextEntry = !isRightButtonPressed
        }
    }
    
    var leftImage:UIImage? {
        didSet {
            if let image = leftImage {
                
                leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
                leftImageView?.image = image
                leftImageView?.contentMode = .center
                leftImageView?.tintColor = text!.isEmpty ? Colors.BLACK  : Colors.BLACK
                
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
    
    var rightImage:UIImage? {
        didSet {
            if let image = rightImage {
                
                rightButtonView = UIButton(frame: CGRect(x: 0, y: 0, width: 24.0, height: 24.0))
                rightButtonView?.setImage(image, for: UIControl.State.normal)
                rightButtonView?.tintColor = Colors.BLACK
                
                let view = UIView(frame: CGRect(x: -6, y: 0, width: 38, height: 40))
                view.addSubview(rightButtonView!)
                rightViewMode = UITextField.ViewMode.always
                rightView = view
                rightButtonView?.center = view.center
                rightButtonView?.addTarget(self, action: #selector(rightButtonWasPressed), for: UIControl.Event.touchUpInside)
                
            } else {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
                rightViewMode = UITextField.ViewMode.always
                rightView = view
                
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
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteText?()
    }
    
    private func setupView() -> Void {
        //placeholderColor(GREY_COLOR)
        textColor = Colors.BLACK
        placeholderColor(Colors.BLACK )
        
        autocorrectionType = .yes
        borderStyle = .none
        layer.borderColor = Colors.BLACK.cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 4
        font = Fonts.ALLER_REGULAR_14
        addTarget(self, action: #selector(self.textEditingChanged), for: UIControl.Event.editingChanged)
        leftImage = nil
        rightImage = nil
        delegate = self
        backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        
        if keyboardType == .emailAddress {
            autocapitalizationType = .none
        } else {
            autocapitalizationType = .sentences

        }
    }
    
    @objc func rightButtonWasPressed() {
        rightButtonPressed?()
    }
    
    @objc func textEditingChanged() -> Void {
        if let imageView = leftImageView {
            imageView.tintColor = text!.isEmpty ? Colors.BLACK  : Colors.BLACK
        }
        textChanged?(text!)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


