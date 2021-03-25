//
//  HistoryHeaderView.swift
//  Movo
//
//  Created by Ahmad on 04/11/2020.
//


import UIKit

class HistoryHeaderView: UIView {
    @IBOutlet weak var dateLbl: UILabel!

    
    var view: UIView!
    
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
        let nib = UINib(nibName: HistoryHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    
    func configureView(str: String) {
        dateLbl.text = str
    }

}

