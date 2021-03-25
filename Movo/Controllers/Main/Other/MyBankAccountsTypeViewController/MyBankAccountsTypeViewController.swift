//
//  MyBankAccountsTypeViewController.swift
//  Movo
//
//  Created by Ahmad on 06/12/2020.
//

import UIKit

class MyBankAccountsTypeTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configureCell(image: UIImage, str: String) {
        imgView.image = image
        titleLbl.text = str
    }
}

class MyBankAccountsTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    private let titlesArray = ["Create Card to Bank Account"]
    private let imagesArray = [Icons.CARD_TO_BANK_ICON]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {

    }
    
    //MARK:- UITableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBankAccountsTypeTableViewCell.className, for: indexPath) as! MyBankAccountsTypeTableViewCell
        cell.configureCell(image: imagesArray[indexPath.row], str: titlesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        let accountType = indexPath.row == 0 ? AccountType.cardToBank : AccountType.bankToCard
        Router.shared.openCreateNewBankAccountViewController( accountType: accountType, controller: self)
    }
}
