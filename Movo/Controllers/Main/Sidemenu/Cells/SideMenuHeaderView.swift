//
//  SideMenuHeaderView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit

class SideMenuHeaderView : UIView {
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    var view: UIView!
    
    @IBOutlet weak var headerBtn: UIButton!
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
        let nib = UINib(nibName: SideMenuHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func configureView(image: UIImage, title:String, isShowRIcon: Bool, isExpanded: Bool) {
        icon.image = image
        lbl.setAttributedTextWithSubscripts(str: title, superScript: "®")
        
        arrowIcon.image = isExpanded ? Icons.ARROW_UP_ICON : Icons.ARROW_DOWN_ICON
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        headerBtnTapped?()
    }
}
