//
//  SideMenuViewController.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import UIKit
import Photos

class SideMenuViewController: UIViewController {

    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    
    
    private let iconsArray = [Icons.SideMenu.MOVO_CASH, Icons.SideMenu.ACTIVATE_CARD, Icons.SideMenu.MOVO_PAY, Icons.SideMenu.CASH_CARD, Icons.SideMenu.DIGITAL_BANKING, Icons.SideMenu.E_CHECKBOOK, Icons.SideMenu.MY_PROFILE_SETTINGS, Icons.SideMenu.LOCK_UNLOCK_CARD, Icons.SideMenu.CHANGE_PASSWORD, Icons.SideMenu.DEPOSIT_HUB, Icons.SideMenu.ABOUT_US]
    
    private var titlesArray = ["MOVO Cash^{®}", "Activate Card", "MOVO Pay^{®}", "CASH Card", "Digital Banking", "eCheckBook", "My Profile/ Settings", "Lock/Unlock Card", "Change Password", "Deposit Hub", "About Us"]
    
    private var expandedSectionsArray = [Bool]()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func resetExpandedList(selectedSection : Int) {
        for (index, _) in expandedSectionsArray.enumerated() {
            if index == selectedSection {
            } else {
                expandedSectionsArray[index] = false
            }
        }
    }

    @objc private func updateProfilePhoto() {
        if let profile = ProfileDetails.instance.getProfileDetails() {
            if let url = URL(string: profile.profileUrl){
                profileImg.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
                imgContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
            } else {
                profileImg.image = Icons.PROFILE_PLACEHOLDER
                imgContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
            }
        }
    }
    
    //MARK:- Helper Methods
    private func setupView() {
        tableView.register(UINib(nibName: SidemenuTableViewCell.className, bundle: nil), forCellReuseIdentifier: SidemenuTableViewCell.className)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: .REFRESH_PROFILE_PHOTO, object: nil)
        
        imgContainer.roundedUIView(withRadius: imgContainer.frame.height/2)
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            nameLbl.text = profile.firstName + " " + profile.lastName
            lastLoginLabel.text = "Last Login: " + profile.lastLogin.getHistoryDateStr()
            if let url = URL(string: profile.profileUrl){
                profileImg.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
                imgContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
            } else {
                profileImg.image = Icons.PROFILE_PLACEHOLDER
                imgContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
            }
        }
        titlesArray.forEach({ (_) in
            expandedSectionsArray.append(false)
        })
    }
    
    //MARK:- IBActions
    @IBAction func profilePhotoButtonWasPressed(_ sender: UIButton) {
        let menuOptions = [CameraMenuOptions.camera,CameraMenuOptions.photolibrary]
        Router.shared.openMenuOptionPopUpVC(options: menuOptions, controller: self) { [weak self](option) in
            DispatchQueue.main.async {
                guard let `self` = self else {return}
                switch option {
                case CameraMenuOptions.camera:
                    self.openCameraWithPermision(type: .image, isFront: true, delegateController: self)
                case CameraMenuOptions.photolibrary:
                    self.openGallary(isVideo: false)
                break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: UIButton) {
        
        showProgressHud()
        let url = API.Account.logout + "/true"
        HooleyAPIGeneric<BoolResponseModel>.fetchRequest(apiURL: url) { [weak self]
            (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    } else {
                        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isUserLogin)
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            delegate.performProfiling()
                        }
                        ProfileDetails.instance.removeProfileOnLogout()
                        ModeSelection.instance.signupMode()
                    }
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}

extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SideMenuType.activateCard.rawValue,SideMenuType.depositHub.rawValue,SideMenuType.cashCard.rawValue,SideMenuType.lockUnlock.rawValue,SideMenuType.changePassword.rawValue,SideMenuType.aboutUs.rawValue:
            return 0
        case SideMenuType.movoCash.rawValue:
            return self.expandedSectionsArray[section] ? Common.shared.getmovoCashArray().count : 0
        case SideMenuType.movoPay.rawValue:
            return self.expandedSectionsArray[section] ? Common.shared.getMovoPayIconsArray().count : 0
        case SideMenuType.digitalBanking.rawValue:
            return self.expandedSectionsArray[section] ? Common.shared.getDigitalBankingIconsArray().count : 0
        case SideMenuType.eCheckbook.rawValue:
            return self.expandedSectionsArray[section] ? Common.shared.geteCheckbookIconsArray().count : 0
        case SideMenuType.myProfile.rawValue:
            return self.expandedSectionsArray[section] ? Common.shared.getProfileSettingIconsArray().count : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SideMenuHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        switch section {
        case SideMenuType.activateCard.rawValue,SideMenuType.depositHub.rawValue,SideMenuType.cashCard.rawValue,SideMenuType.lockUnlock.rawValue,SideMenuType.changePassword.rawValue,SideMenuType.aboutUs.rawValue:
            view.arrowIcon.isHidden = true
        default:
            view.arrowIcon.isHidden = false
        }
        
        view.headerBtnTapped = {
            switch section {
            case SideMenuType.activateCard.rawValue,SideMenuType.depositHub.rawValue,SideMenuType.cashCard.rawValue,SideMenuType.lockUnlock.rawValue,SideMenuType.changePassword.rawValue,SideMenuType.aboutUs.rawValue:
                self.hideLeftView(self)
                let userInfo = [K.SECTION: section, K.ROW:0]
                NotificationCenter.default.post(name: .SIDE_MENU_OPTION_CLICKED, object: nil, userInfo: userInfo)
            default:
                self.resetExpandedList(selectedSection: section)
                self.expandedSectionsArray[section] = !self.expandedSectionsArray[section]
                DispatchQueue.main.async {
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                }
            }
        }
        
        view.configureView(image: iconsArray[section], title: titlesArray[section], isShowRIcon: section == 0 || section == 2, isExpanded: self.expandedSectionsArray[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SideMenuType.activateCard.rawValue {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SidemenuTableViewCell.className) as! SidemenuTableViewCell
        
        switch indexPath.section {
        case SideMenuType.activateCard.rawValue,SideMenuType.depositHub.rawValue,SideMenuType.cashCard.rawValue,SideMenuType.lockUnlock.rawValue,SideMenuType.changePassword.rawValue,SideMenuType.aboutUs.rawValue:
            return UITableViewCell()
        case SideMenuType.movoCash.rawValue:
            cell.configureCell(image: Common.shared.getMovoCashIconsArray()[indexPath.row], title: Common.shared.getMovoCashTitlesArray()[indexPath.row])
        case SideMenuType.movoPay.rawValue:
            cell.configureCell(image: Common.shared.getMovoPayIconsArray()[indexPath.row], title: Common.shared.getMovoPayTitlesArray()[indexPath.row])
        case SideMenuType.digitalBanking.rawValue:
            cell.configureCell(image: Common.shared.getDigitalBankingIconsArray()[indexPath.row], title: Common.shared.getDigitalBankingTitlesArray()[indexPath.row])
        case SideMenuType.eCheckbook.rawValue:
            cell.configureCell(image: Common.shared.geteCheckbookIconsArray()[indexPath.row], title: Common.shared.getEheckbookTitlesArray()[indexPath.row])
        case SideMenuType.myProfile.rawValue:
            cell.configureCell(image: Common.shared.getProfileSettingIconsArray()[indexPath.row], title: Common.shared.getProfileSettingTitlesArray()[indexPath.row])
        default:
            return UITableViewCell()
        }
        
        cell.cellTapped = {
            self.hideLeftView(self)
            let userInfo = [K.SECTION: indexPath.section, K.ROW:indexPath.row]
            NotificationCenter.default.post(name: .SIDE_MENU_OPTION_CLICKED, object: nil, userInfo: userInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SideMenuType.myProfile.rawValue {
            if indexPath.row == SideMenuProfileSettingType.passcode.rawValue { // hide passcode from sidemenu
                return 0
            } else {
                return 50
            }
        } else if indexPath.section == SideMenuType.movoPay.rawValue {
            if indexPath.row == SideMenuMovoPayType.socialMedia.rawValue {
                return 0
            } else {
                return 50
            }
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}


extension SideMenuViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerCustomViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.imageUploadApi(image: originalImage)
                }
            }
        })
    }
    
    func getSelectedMedia(assets: [PHAsset]) {
        assets.forEach { (asset) in
            Common.getImageFromAsset(asset: asset) { [weak self] (image) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if let img = image {
                        self.imageUploadApi(image: img)
                    }
                }
            }
        }
    }
    
    func imageUploadApi(image: UIImage) {
        
        let img = image.fixImageOrientation()
        self.showProgressHud()
        let requestModel = MediaUploadRequestModel.init(type: MediaType.image.rawValue)
        
        let media = Media(withImage: img, forKey: K.MEDIA_FILE_KEY)
        HooleyPostMultipartAPIGeneric<MediaUploadRequestModel, MediaUploadResponseModel>.fetchRequest(apiURL: API.Upload.media, media: [media!], requestModel: requestModel) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let `self` = self else {return}
                self.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if let item = responseModel.data?.first {
                        if let profile = ProfileDetails.instance.getProfileDetails() {
                            profile.profileUrl = item.thumbURL ?? ""
                            ProfileDetails.instance.saveProfileDetails(instance: profile)
                        }
                        self.updateProfilePhotoAPICall(profileUrl: item.url ?? "", thumbnailUrl: item.thumbURL ?? "")
                    }
                    NotificationCenter.default.post(name: .REFRESH_PROFILE_PHOTO, object: nil)
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func openGallary(isVideo: Bool = false){
        if #available(iOS 14, *) {
            Router.shared.openImagePickerCustomViewController(mediaType: isVideo ? .video : .image, controller: self)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
}

extension SideMenuViewController {
    private func updateProfilePhotoAPICall(profileUrl: String, thumbnailUrl: String) {

        let requestModel = UpdateProfilePictureRequestModel(profilePicture: profileUrl, profilePictureThumb: thumbnailUrl)
        
        showProgressHud()
        HooleyPostAPIGeneric<UpdateProfilePictureRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.updateprofilepicture, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        print(responseModel)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
