//
//  AccountSummaryHeaderView.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//

import UIKit

class AccountsSummaryHeaderView: UIView {

    @IBOutlet weak var button: BlackBGButton!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var viewAllButton: UIButton!
    
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
        let nib = UINib(nibName: AccountsSummaryHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    
    func configureView(str: String, isExpanded:Bool, isShowViewAllButton: Bool) {
        button.roundedUIView(withRadius: 2.0)
        button.setTitle(str, for: .normal)
        arrowIcon.image = isExpanded ? Icons.ARROW_UP_ICON : Icons.ARROW_DOWN_ICON
        
        viewAllButton.isHidden = isShowViewAllButton ? false : true
        arrowIcon.isHidden = isShowViewAllButton ? true : false
    }
    
    @IBAction func btnWasPressed(_ sender: BlackBGButton) {
        headerBtnTapped?()
    }

}
