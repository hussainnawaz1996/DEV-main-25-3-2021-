//
//  UITableView+Extension.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

extension UITableView {
    
    func removeSelection() -> Void {
        if let indexs = self.indexPathsForSelectedRows{
            indexs.forEach({ (indexPath) in
                self.deselectRow(at: indexPath, animated: true)
            })
        }
    }
}
