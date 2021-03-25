//
//  ProfileScreenHeaderView.swift
//  Movo
//
//  Created by Ahmad on 02/11/2020.
//

import UIKit

class ProfileScreenHeaderView: UIView {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var view: UIView!
    var profileBtnTapped:(()->())?
    
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
        let nib = UINib(nibName: ProfileScreenHeaderView.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func configureView() {
        mainContainer.roundedUIView(withRadius: mainContainer.frame.height/2)
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            nameLbl.text = profile.firstName + " " + profile.lastName
            if let url = URL(string: profile.profileUrl){
                profileImg.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
                mainContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
            } else {
                profileImg.image = Icons.PROFILE_PLACEHOLDER
                mainContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
            }
        }
        
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            
            if let cardModel = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: cardModel)
                let balanceStr = (cardModel.balance ?? "0.0").get2DigitDecimalString() 
                balanceLbl.text = "$" + balanceStr + "USD"
            }
        }
    }
    
    @IBAction func profileButtonWasPressed(_ sender: UIButton) {
        profileBtnTapped?()
    }

}
