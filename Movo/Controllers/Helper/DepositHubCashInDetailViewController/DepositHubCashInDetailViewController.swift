//
//  DepositHubCashInDetailViewController.swift
//  Movo
//
//  Created by Ahmad on 11/12/2020.
//

import UIKit

class DepositHubCashInDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: DepositHubCashInHeaderViewCell.className, bundle: nil), forCellReuseIdentifier: DepositHubCashInHeaderViewCell.className)
        tableView.register(UINib(nibName: DepositHubCashInDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: DepositHubCashInDetailTableViewCell.className)
        
        tableView.tableFooterView = UIView()
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension DepositHubCashInDetailViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        default:
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DepositHubCashInHeaderViewCell.className, for: indexPath) as! DepositHubCashInHeaderViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DepositHubCashInDetailTableViewCell.className, for: indexPath) as! DepositHubCashInDetailTableViewCell
            return cell
            
        }
    }

}
