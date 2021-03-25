//
//  CGFloat+Extension.swift
//  Movo
//
//  Created by Ahmad on 20/03/2021.
//

import UIKit

extension CGFloat {
    
    func toRadians() -> CGFloat {
        return self / (180 * .pi)
    }
    
    func toDegrees() -> CGFloat {
        return self * (180 * .pi)
    }
}
