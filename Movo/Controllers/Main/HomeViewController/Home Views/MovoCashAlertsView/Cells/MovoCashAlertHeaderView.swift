//
//  MovoCashAlertHeaderView.swift
//  Movo
//
//  Created by Ahmad on 23/11/2020.
//

import UIKit

class MovoCashAlertHeaderView: UIView {

    @IBOutlet weak var button: BlackBGButton!
    @IBOutlet weak var addButton: UIButton!
    
    var view: UIView!
    var headerBtnTapped:(()->())?
    var addButtonTapped:(()->())?
    
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
        let nib = UINib(nibName: MovoCashAlertHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    
    func configureView(model: CashAlertModel, isExpanded:Bool, isShowAddButton: Bool) {
        button.roundedUIView(withRadius: 2.0)
        button.setTitle(model.name, for: .normal)
        
        addButton.isHidden = isShowAddButton ? false : true
    }
    
    @IBAction func btnWasPressed(_ sender: BlackBGButton) {
        headerBtnTapped?()
    }
    
    @IBAction func addButtonWasPressed(_ sender: UIButton) {
        addButtonTapped?()
    }
    

}
