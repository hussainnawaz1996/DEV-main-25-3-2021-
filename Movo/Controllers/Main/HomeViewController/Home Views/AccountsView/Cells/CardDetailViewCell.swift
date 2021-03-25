//
//  CardDetailViewCell.swift
//  Movo
//
//  Created by Ahmad on 25/11/2020.
//

import UIKit


class CardDetailViewCell: UITableViewCell {
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    var hideCardButtonTapped:(()->())?
    var cardNumberCopied:(()->())?
    private var cardModel : CardModel?
    
    func configureCell(model: CardModel) {
        
        self.cardModel = model
        
        let userName = (model.firstName ?? "") + " " + (model.lastName ?? "")
        cardView.configure(accountNumber: model.cardNumber ?? "", expiry: model.expiryDate ?? "", name: userName, cvv: model.ccv)

        let str = "BY USING THE MOVO APP^{™} AND CARD YOU AGREE WITH THE TERMS AND CONDITIONS OF THE MOVO^{®} DIGITAL BANK ACCOUNT AND DEBIT MASTERCARD^{®} AGREEMENT AND FEE SCHEDULE. Banking services provided by Coastal Community Bank, Member FDIC. The MOVO^{®} Debit Mastercard^{®} is issued by Coastal Community Bank, Member FDIC, pursuant to license by Mastercard International."
        descriptionLbl.setAttributedTextWithSubscripts(str: str)

    }
    
    @IBAction func copyCardNumberButtonWasPressed(_ sender: BlackBGButton) {
        let pasteboard = UIPasteboard.general
        if let model = cardModel {
            pasteboard.string = model.cardNumber
        }
//        self.contentView.showToast(message: "Card number copied!")
        cardNumberCopied?()
    }
    
    @IBAction func hideCardButtonWasPressed(_ sender: GrayButton) {
        hideCardButtonTapped?()
    }
}
