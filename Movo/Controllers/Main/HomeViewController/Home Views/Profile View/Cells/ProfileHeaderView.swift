//
//  ProfileHeaderView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var button: BlackBGButton!
    @IBOutlet weak var arrowIcon: UIImageView!
    
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
        let nib = UINib(nibName: ProfileHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func configureView(str: String, isExpanded:Bool) {
        button.roundedUIView(withRadius: 2.0)
        button.setTitle(str, for: .normal)
        arrowIcon.image = isExpanded ? Icons.ARROW_UP_ICON : Icons.ARROW_DOWN_ICON
    }
    
    @IBAction func btnWasPressed(_ sender: BlackBGButton) {
        headerBtnTapped?()
    }
}