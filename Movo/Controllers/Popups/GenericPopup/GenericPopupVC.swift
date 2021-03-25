//
//  GenericPopupVC.swift
//  Movo
//
//  Created by Ahmad on 05/11/2020.
//

import UIKit

struct GenericPopupModelList {
    let list :  [GenericPopupModel]
}

struct GenericPopupModel {
    let headerTitle: String
    let subtitles : [SubTitleModel]
}

struct SubTitleModel {
    let cardNumber: String
    let balance: String
}

struct SelectedIndexModel {
    var section : Int
    var row : Int
}

class GenericPopupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var selectionIcon: UIImageView!
    
    func configureCell(cardNumber: String, balanceStr:String,  isSelected: Bool) {
        titleLbl.text = "MOVO Card *" + cardNumber
        subTitleLbl.text = "Balance: $" + balanceStr + "USD"
        selectionIcon.image = isSelected ? Icons.POPUP_SELECTION_ICON : Icons.POPUP_UNSELECTION_ICON
    }
    
}

class GenericPopupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    private var expandedList = [Bool]()
    private var selectedIndex = SelectedIndexModel(section: -1, row: -1)

    var model : GenericPopupModelList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initializeExpandedList()
        if model.list.count > 0 {
            expandedList[0] = true
        }
        getHeightConstraint()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.8)
            
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.8)
            
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.0)
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initializeExpandedList() {
        for _ in 0...model.list.count - 1  {
            expandedList.append(false)
        }
    }
    
    private func resetExpandedList() {
        for i in 0...model.list.count - 1 {
            expandedList[i] = false
        }
    }
    
    private func getHeightConstraint() {
        var height : CGFloat = 0.0
        height = height + CGFloat(model.list.count * 50)
        
        for i in 0 ... model.list.count - 1 {
            if expandedList[i] {
                height = height + CGFloat(model.list[i].subtitles.count * 50)
            }
        }
        
        heightConstraint.constant = height
    }
    
    //MARK:- UITableView Deleagates
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.list.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = GenericPopupHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        view.configureView(str: model.list[section].headerTitle, isExpanded: expandedList[section])
        
        view.headerBtnTapped = {
            self.resetExpandedList()
            self.expandedList[section] = true
            DispatchQueue.main.async {
                self.getHeightConstraint()
                self.tableView.reloadData()
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedList[section] ? model.list[section].subtitles.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericPopupTableViewCell.className, for: indexPath) as! GenericPopupTableViewCell
        let m = model.list[indexPath.section].subtitles[indexPath.row]
        let isSelected = (selectedIndex.section == indexPath.section && selectedIndex.row == indexPath.row)
        cell.configureCell(cardNumber: m.cardNumber, balanceStr: m.balance, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedList[indexPath.section] ? 50 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex.section = indexPath.section
        selectedIndex.row = indexPath.row
        tableView.reloadData()
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
