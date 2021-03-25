//
//  GenericPopupHeaderView.swift
//  Movo
//
//  Created by Ahmad on 05/11/2020.
//

import UIKit

class GenericPopupHeaderView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var button: UIButton!
    
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
        let nib = UINib(nibName: GenericPopupHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func configureView(str: String, isExpanded:Bool) {
        titleLbl.text = str
        arrowIcon.image = isExpanded ? Icons.ARROW_RIGHT_ICON : Icons.ARROW_DOWN_ICON
    }
    
    @IBAction func btnWasPressed(_ sender: UIButton) {
        headerBtnTapped?()
    }
}
