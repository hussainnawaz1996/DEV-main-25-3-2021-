//
//  MenuOptionPopUpVC.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit

typealias MenuOptionSelectionCompletionHandler = ((MenuOptions)-> ())

protocol MenuOptions {
    func getRawValue() -> String
}



enum CameraMenuOptions:String,CaseIterable,MenuOptions {
    
    case camera = "Take Picture"
    case photolibrary = "Photo Library"
    
    func getRawValue() -> String {
        return self.rawValue
    }
}

class PopUpOptionTableViewCell: UITableViewCell {
    
    @IBOutlet var optionTitleLabel: UILabel!
    
    func configureCell(option:MenuOptions, isEnable:Bool) -> Void {
        optionTitleLabel.text = option.getRawValue()
        
        optionTitleLabel.textColor = isEnable ? Colors.BLACK : Colors.WHITE
        optionTitleLabel.font = Fonts.HELVETICA_REGULAR_17
    }
}

class MenuOptionPopUpVC: UIViewController, UITableViewDelegate,UITableViewDataSource,PanModalPresentable  {

    @IBOutlet var tableView: UITableView!
    
    var selectionHandler:MenuOptionSelectionCompletionHandler?
    
    var options = [MenuOptions]()
    var selectedOption:MenuOptions?
    var isEnable = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = Colors.SEPARATOR_COLOR
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        panModalTransition(to: .longForm)
        tableView.roundWithCorners(corners: [.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 10)
        tableView.clipsToBounds = true
    }
    
    //MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpOptionTableViewCell.className, for: indexPath) as! PopUpOptionTableViewCell
        cell.configureCell(option: options[indexPath.row], isEnable: self.isEnable)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        dismiss(animated: true) {
            self.selectionHandler?(self.options[indexPath.row])
        }
        
    }
    
    // MARK: - Pan Modal Presentable
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        panModalSetNeedsLayoutUpdate()
    }
}
