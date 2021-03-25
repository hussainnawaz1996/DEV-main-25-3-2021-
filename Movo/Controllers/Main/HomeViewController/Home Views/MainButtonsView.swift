//
//  MainButtonsView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit


class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var buttonTapped : ((Int)->())?
    private var index = -1
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonTapped?(index)
    }
    
    func configureCell(isSelected: Bool, icon: UIImage, title: String, index: Int) {
        self.index = index
        mainView.roundedUIView(withRadius: 8)
        mainView.backgroundColor = isSelected ? Colors.BLACK : Colors.WHITE
        button.setTitle(title, for: .normal)
        imgView.image = icon
        if isSelected {
            button.setTitleColor(Colors.WHITE, for: .normal)
            button.titleLabel?.font = Fonts.ALLER_BOLD_14
        } else {
            button.setTitleColor(Colors.BLACK, for: .normal)
            button.titleLabel?.font = Fonts.ALLER_REGULAR_12
        }
    }
    
}

class MainButtonsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedIndex = -1
    private var selectedIconsArray = [Icons.Home.MO_PRO_SELECTED, Icons.Home.CREDIT_SELECTED, Icons.Home.TERMS_SELECTED, Icons.Home.PRIVACY_SELECTED, Icons.Home.CHANGE_PASSWORD_SELECTED]
    private var unSelectedIconsArray = [Icons.Home.MO_PRO_UNSELECTED, Icons.Home.CREDIT_UNSELECTED, Icons.Home.TERMS_UNSELECTED, Icons.Home.PRIVACY_UNSELECTED, Icons.Home.CHANGE_PASSWORD_UNSELECTED]
    private var titlesArray = ["MoPro Support", "MOVO Credit", "Terms and Conditions", "Privacy Policy", "Change Password"]
    
    
    var controller: UIViewController? = nil

    func configureView(controller: UIViewController) {
        self.controller = controller

    }
    
    //MARK:- UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.className, for: indexPath) as! HomeTableViewCell
        let isSelected = selectedIndex == indexPath.row
        let icon = isSelected ? selectedIconsArray[indexPath.row] : unSelectedIconsArray[indexPath.row]
        cell.configureCell(isSelected: isSelected, icon: icon, title: titlesArray[indexPath.row], index: indexPath.row)
        
        cell.buttonTapped = { index in
            self.selectedIndex = index
            var userInfo = [String:Int]()
            switch index {
            case 0:
                userInfo = [K.SECTION: SideMenuType.myProfile.rawValue, K.ROW:3]
            case 1:
                break
            case 2:
                userInfo = [K.SECTION: SideMenuType.myProfile.rawValue, K.ROW:4]
            case 3:
                userInfo = [K.SECTION: SideMenuType.myProfile.rawValue, K.ROW:5]
            case 4:
                userInfo = [K.SECTION: SideMenuType.changePassword.rawValue, K.ROW:0]
            default:
                userInfo = [K.SECTION: indexPath.section, K.ROW:indexPath.row]
            }
            
            if index != 1{
                NotificationCenter.default.post(name: .SIDE_MENU_OPTION_CLICKED, object: nil, userInfo: userInfo)
            }
            
            self.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
