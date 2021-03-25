//
//  NSObject+Extension.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import Foundation

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
