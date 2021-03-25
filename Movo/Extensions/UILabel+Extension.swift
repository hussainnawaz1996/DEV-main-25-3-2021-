//
//  UILabel+Extension.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

extension UILabel {
//    func setAttributedTextWithSubscripts(str: String, superScript: Character = "®") {
//        let indices = str.indexInt(of: superScript)
//        let superScriptFont = font.withSize(font.pointSize * 0.7)
//        let superScriptOffset = 10
//        let attributedString = NSMutableAttributedString(string: str,
//                                                         attributes: [.font : font ?? Fonts.ALLER_REGULAR_17!])
//
//        if indices.isEmpty {
//            self.text = str
//        } else {
//            for index in indices {
//                let range = NSRange(location: index, length: 1)
//                attributedString.setAttributes([.font: superScriptFont,
//                                                .baselineOffset: superScriptOffset],
//                                               range: range)
//                self.attributedText = attributedString
//            }
//        }
//    }
    
    func setAttributedTextWithSubscripts(str: String, superScript: Character = "®") {
        self.attributedText = str.superscripted(font: self.font ?? Fonts.ALLER_REGULAR_17!)

    }
}
