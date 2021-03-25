//
//  CardView.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var expiryLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var cvvLbl: UILabel!
    
    var view: UIView!
    var headerBtnTapped:(()->())?
    
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
        let nib = UINib(nibName: CardView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func configure(accountNumber:String, expiry:String, name:String, cvv:String?) {
        
        let count = accountNumber.count
        if count == 16 {
            let arrayOf4Characters = accountNumber.splitedBy(length: 4).joined(separator: "   ")
            accountNumberLbl.text = arrayOf4Characters
        } else {
            accountNumberLbl.text = accountNumber
        }
        expiryLbl.text = expiry.getCardExpiryDateStr()
        usernameLbl.text = name
        cvvLbl.text = "CVC " + (cvv ?? "")
    }
}
