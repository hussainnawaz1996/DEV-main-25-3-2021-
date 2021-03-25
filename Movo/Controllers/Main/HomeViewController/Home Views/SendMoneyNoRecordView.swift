//
//  SendMoneyNoRecordView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit

class SendMoneyNoRecordView: UIView {

    @IBOutlet weak var movoCardNumber: UILabel!
    @IBOutlet weak var availableBalanceLbl: UILabel!
    
    var headerButtonTapped:(()->())?
    var controller: UIViewController? = nil
    private var selectedCard: CardModel?

    func configureView(cardNumber:String, balance:String, controller: UIViewController) {
        self.controller = controller
    }
    
    func setup() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            if let firstCard = cardModel.cards?.first {
                selectedCard = firstCard
                availableBalanceLbl.text = "$" + (selectedCard?.balance ?? "") + " USD"
                movoCardNumber.text = Common.shared.getFormattedCardNumber(model: firstCard)

            }
        }
    }
    
    @IBAction func headerTapped(_ sender: UIButton) {
        headerButtonTapped?()
    }
}
