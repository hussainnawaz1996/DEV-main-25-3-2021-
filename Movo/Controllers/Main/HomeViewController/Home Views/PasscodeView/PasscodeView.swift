//
//  PasscodeView.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class PasscodeTableViewCell: UITableViewCell {
    
}

class PasscodeView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil

    func configureView(controller: UIViewController) {
        self.controller = controller
        tableView.tableFooterView = UIView()
    }

    //MARK:- UITableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PasscodeTableViewCell.className, for: indexPath) as! PasscodeTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.openPasscodeSettingsViewController(controller: controller!)
    }
}
