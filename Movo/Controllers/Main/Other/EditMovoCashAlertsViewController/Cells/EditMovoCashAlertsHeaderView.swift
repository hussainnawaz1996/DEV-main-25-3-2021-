//
//  EditMovoCashAlertsHeaderView.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

class EditMovoCashAlertsHeaderView: UIView {
    @IBOutlet weak var cardNumberLabel: UILabel!
    
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
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func configureView() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            if let primaryCard = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                cardNumberLabel.text = Common.shared.getFormattedCardNumber(model: primaryCard)
            }
        }
    }
    
    @IBAction func headerButtonWasPressed(_ sender: UIButton) {
        headerBtnTapped?()
    }
}

