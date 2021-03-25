//
//  AccountsHeaderView.swift
//  Movo
//
//  Created by Ahmad on 25/11/2020.
//

import UIKit

class AccountsHeaderView: UIView {

    
    @IBOutlet weak var cardStatusIcon: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var accountTypeLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var lastActivityLbl: UILabel!
    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var viewCardButton: BlackBGNoFontButton!
    
    var view: UIView!
    var viewCardButtonTapped :(()->())?
    var headerButtonTapped :(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: AccountsHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func configureView(model: CardModel, showViewCardButton: Bool) {
        mainView.roundedUIView(withRadius: 12.0)
        
        let statusCode = model.statusCode ?? "F"
        if statusCode == CardStatusIcon.closed.rawValue || statusCode == CardStatusIcon.inActive.rawValue {
            cardStatusIcon.image = Icons.CARD_STATUS_FAILED_ICON
        } else {
            cardStatusIcon.image = Icons.CARD_STATUS_SUCCESS_ICON
        }
        accountTypeLbl.text = Common.shared.isPrimaryCard(model: model) ? "Primary Account" : "Secondary Account"
        
        accountNumberLbl.text = Common.shared.getFormattedCardNumber(model: model)
        
        let amountDouble = Double(model.balance ?? "0.0") ?? 0.0
        amountLbl.text = "$" + amountDouble.numberFormatter(digitAfterPoint: 2 )
        let lastDepositDate = (model.lastDepositDate ?? "")
        lastActivityLbl.text = lastDepositDate.isEmpty ? "-" : lastDepositDate.getHistoryDateStr()
        let expiryDate = (model.expiryDate ?? "")
        expireDateLbl.text = expiryDate.isEmpty ? "-" : expiryDate.getHistoryDateStr()
        
        viewCardButton.isHidden = showViewCardButton ? false : true
    }
    
    @IBAction func viewCardButtonTapped(_ sender: BlackBGNoFontButton) {
        viewCardButtonTapped?()
    }
    
    @IBAction func headerButtonWasPressed(_ sender: UIButton) {
        headerButtonTapped?()
    }
}

