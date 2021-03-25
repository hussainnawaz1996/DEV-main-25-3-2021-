//
//  CashOutToBankCommentsTableViewCell.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

class CashOutToBankCommentsTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var textChanged:((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let str = textView.text ?? ""
        textChanged?(str)
    }
    
}
