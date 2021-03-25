//
//  AboutUsView.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movoTitleLbl: UILabel!
    @IBOutlet weak var poweredByLbl: UILabel!
    @IBOutlet weak var copyrightLbl: UILabel!
    @IBOutlet weak var bottomTextLbl: UILabel!
    
    func configureCell() {
        movoTitleLbl.setAttributedTextWithSubscripts(str: "MOVO^{®}")
        poweredByLbl.setAttributedTextWithSubscripts(str: "Powered by MOVO^{®} Cash, Inc.")
        copyrightLbl.setAttributedTextWithSubscripts(str: "Copyright 2014 MOVO^{®} Cash, Inc. All Rights Reserved.")
        let str = "BY USING THE MOVO APP^{™} AND CARD YOU AGREE WITH THE TERMS AND CONDITIONS OF THE MOVO^{®} DIGITAL BANK ACCOUNT AND DEBIT MASTERCARD^{®} AGREEMENT AND FEE SCHEDULE. Banking services provided by Coastal Community Bank, Member FDIC. The MOVO^{®} Debit Mastercard^{®} is issued by Coastal Community Bank, Member FDIC, pursuant to license by Mastercard International."
        bottomTextLbl.setAttributedTextWithSubscripts(str: str)

    }
}

class AboutUsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var controller: UIViewController? = nil
    
    func configureView(controller: UIViewController) {
        self.controller = controller
    }
    
    func setup() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutUsTableViewCell.className, for: indexPath) as! AboutUsTableViewCell
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    
   
}
