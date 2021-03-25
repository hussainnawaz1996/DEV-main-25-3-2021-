//
//  SelectAccountPopupVC.swift
//  Movo
//
//  Created by Ahmad on 28/11/2020.
//

import UIKit

protocol SelectAccountPopupVCDelegate: class {
    func getSelectedAccount(model: CardModel?)
}

class SelectAccountPopupVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private var primaryCardsArray = [CardModel]()
    private var secondaryCardsArray = [CardModel]()
    private var selectedIndex = SelectedIndexModel(section: -1, row: -1)
    private var expandedList = [Bool]()
    
    var delegate: SelectAccountPopupVCDelegate?
    var isOnlyShowPrimaryAccounts = false
    var selectedCard : CardModel?

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(UINib(nibName: SelectAccountTableViewCell.className, bundle: nil), forCellReuseIdentifier: SelectAccountTableViewCell.className)
        
        setupView()
        
        tableView.tableHeaderView = SelectAccountTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
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
    
    private func setupView() {
        
        initializeExpandedList()
        initializeArray()
        if let card = selectedCard {
            if let index = primaryCardsArray.lastIndex(where: {$0.cardNumber == card.cardNumber}) {
                selectedIndex = SelectedIndexModel(section: 0, row: index)
            }
            
            if let index = secondaryCardsArray.lastIndex(where: {$0.cardNumber == card.cardNumber}) {
                selectedIndex = SelectedIndexModel(section: 1, row: index)
            }
        } else {
            selectedIndex = SelectedIndexModel(section: 0, row: 0)
        }
        self.tableView.reloadData()
    }
    
    private func initializeExpandedList() {
        expandedList.removeAll()
        for _ in 0 ... 1  {
            expandedList.append(false)
        }
    }
    
    private func resetExpandedList(selectedSection: Int) {
        for i in 0 ... 1  {
            if i == selectedSection {
            } else {
                expandedList[i] = false
            }
        }
    }
    
    private func initializeArray() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            let array  = cardModel.cards
            
            primaryCardsArray = array?.filter({Common.shared.isPrimaryCard(model: $0)}) ?? []
            secondaryCardsArray = array?.filter({Common.shared.isPrimaryCard(model: $0) == false }) ?? []
            
            if primaryCardsArray.count > 0 {
                expandedList[0] = true
            }
            setHeightConstraint()
            
        }
    }
    
    private func setHeightConstraint() {
        var height : CGFloat = 0.0

        if expandedList[0] {
            height = height + CGFloat(primaryCardsArray.count * 50)
        }
        
        if expandedList[1] {
            height = height + CGFloat(secondaryCardsArray.count * 50)
        }
        
        if isOnlyShowPrimaryAccounts {
            height = height + 50 + 50 // for table header, primary section header
        } else {
            height = height + 50 + 50 + 50 // for table header, primary section header and secondary section heder
        }
        heightConstraint.constant = height
        tableView.isScrollEnabled = height >= UIScreen.main.bounds.height
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func accountSelected(){
        self.dismiss(animated: true) {
            if self.selectedIndex.section == 0 {
                self.delegate?.getSelectedAccount(model: self.primaryCardsArray[self.selectedIndex.row])

            } else if self.selectedIndex.row == 1 {
                self.delegate?.getSelectedAccount(model: self.secondaryCardsArray[self.selectedIndex.row])
            }
        }
    }
}

extension SelectAccountPopupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return expandedList[section] ? primaryCardsArray.count : 0
        default:
            if isOnlyShowPrimaryAccounts {
                return 0
            } else {
                return expandedList[section] ? secondaryCardsArray.count : 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAccountTableViewCell.className, for: indexPath) as! SelectAccountTableViewCell
        let isSelected = (selectedIndex.section == indexPath.section && selectedIndex.row == indexPath.row)

        switch indexPath.section {
        case 0:
            cell.configureCell(cardModel: primaryCardsArray[indexPath.row], isSelected: isSelected)
        default:
            cell.configureCell(cardModel: secondaryCardsArray[indexPath.row], isSelected: isSelected)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedList[indexPath.section] ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex.section = indexPath.section
        selectedIndex.row = indexPath.row
        tableView.reloadData()

        self.accountSelected()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SelectAccountHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50 ))
        let str = section == 0 ? "Primary Card Account(s)" : "Secondary Card Account(s)"
        view.configureView(str: str, isExpanded: expandedList[section])
        
        view.headerBtnTapped = {
            self.resetExpandedList(selectedSection: section)
            self.expandedList[section] = !self.expandedList[section]
            DispatchQueue.main.async {
                self.setHeightConstraint()
                self.tableView.reloadData()
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        default:
            return isOnlyShowPrimaryAccounts ? 0 : 50
        }
    }
    
}
