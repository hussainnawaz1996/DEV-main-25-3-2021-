//
//  SidemenuTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit

class SidemenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    var cellTapped :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(image: UIImage, title:String) {
        icon.image = image
        lbl.setAttributedTextWithSubscripts(str: title)
        
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
        cellTapped?()
    }
    
}
