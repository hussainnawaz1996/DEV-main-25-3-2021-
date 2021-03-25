//
//  DirectDepositView.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class DirectDepositView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    func configureView(controller: UIViewController) {
        self.controller = controller
        
        tableView.register(UINib(nibName: DirectDepositFundsTableViewCell.className, bundle: nil), forCellReuseIdentifier: DirectDepositFundsTableViewCell.className)
        tableView.register(UINib(nibName: DirectDepositInformationTableViewCell.className, bundle: nil), forCellReuseIdentifier: DirectDepositInformationTableViewCell.className)

        tableView.register(UINib(nibName: DirectDepositAuthorizationTableViewCell.className, bundle: nil), forCellReuseIdentifier: DirectDepositAuthorizationTableViewCell.className)

        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectDepositFundsTableViewCell.className, for: indexPath) as! DirectDepositFundsTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectDepositInformationTableViewCell.className, for: indexPath) as! DirectDepositInformationTableViewCell
            cell.confiugreCell()
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectDepositAuthorizationTableViewCell.className, for: indexPath) as! DirectDepositAuthorizationTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
