//
//  UIButton+Extension.swift
//  Movo
//
//  Created by Ahmad on 05/12/2020.
//

import UIKit

extension UIButton {
    func setButtonAttributedTextWithSubscripts(str: String, superScript: Character = "®") {
        self.setAttributedTitle(str.superscripted(font: self.titleLabel?.font ?? Fonts.ALLER_REGULAR_17!), for: .normal)
    }
}
