//
//  TransferActivityHeaderView.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class TransferActivityHeaderView: UIView {

    @IBOutlet weak var dateLbl: UILabel!
    
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
        let nib = UINib(nibName: TransferActivityHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    
    func configureView(str: String) {
        dateLbl.text = str
    }

}
