//
//  ProfileView.swift
//  Movo
//
//  Created by Ahmad on 01/11/2020.
//

import UIKit
import Photos

class ProfileViewFirstTableViewCell: UITableViewCell {
    
}

class ProfileView: UIView, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    private var expandedList = [true, true, true]
    var controller: UIViewController? = nil
    
    private var tableHeader : ProfileScreenHeaderView?

    private var statesArray = [StateModel]()
    private var profileModel : ProfileHolderResponseModel?
    private var selectedState : StateModel?
    private var selectedBillingState : StateModel?
    
    private var email = ""
    private var phone = ""
    private var address = ""
    private var city = ""
    private var zip = ""
    private var billingAddress = ""
    private var billingCity = ""
    private var billingZip = ""
    
    func configureView(controller: UIViewController) {
        self.controller = controller
        
        tableView.register(UINib(nibName: ProfileTableViewCell.className, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.className)
        tableView.register(UINib(nibName: ContactInformationTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContactInformationTableViewCell.className)
        tableView.register(UINib(nibName: AddressInformationTableViewCell.className, bundle: nil), forCellReuseIdentifier: AddressInformationTableViewCell.className)
        tableView.register(UINib(nibName: ShippingInformationTableViewCell.className, bundle: nil), forCellReuseIdentifier: ShippingInformationTableViewCell.className)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: .REFRESH_PROFILE_PHOTO, object: nil)

        
        tableHeader = ProfileScreenHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 130))
        tableHeader?.configureView()
        tableView.tableHeaderView = tableHeader
        tableHeader?.profileBtnTapped = {
            let menuOptions = [CameraMenuOptions.camera,CameraMenuOptions.photolibrary]
            Router.shared.openMenuOptionPopUpVC(options: menuOptions, controller: self.controller!) { [weak self](option) in
                DispatchQueue.main.async {
                    guard let `self` = self else {return}
                    switch option {
                    case CameraMenuOptions.camera:
                        self.controller?.openCameraWithPermision(type: .image, isFront: true, delegateController: self.controller!)
                    case CameraMenuOptions.photolibrary:
                        self.openGallary(isVideo: false)
                    break
                    default:
                        break
                    }
                }
            }
        }
        tableView.tableFooterView = UIView()
    }
    
    func setup() {
        getStates()
        tableHeader?.configureView()
    }
    
    //MARK:- Helper Methods
    
    @objc private func updateProfilePhoto() {
        tableHeader?.configureView()
    }
    
    private func openGallary(isVideo: Bool = false){
        if #available(iOS 14, *) {
            Router.shared.openImagePickerCustomViewController(mediaType: isVideo ? .video : .image, controller: self.controller!)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self.controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            self.controller?.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    //MARK:- UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return expandedList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        switch section {
        case 0:
            view.configureView(str: "Contact Information", isExpanded: expandedList[section])
        case 1:
            view.configureView(str: "Address Information", isExpanded: expandedList[section])
        default:
            view.configureView(str: "Shipping Information", isExpanded: expandedList[section])
        }
        
        view.headerBtnTapped = {
            self.expandedList[section] = !self.expandedList[section]
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(section...section), with: UITableView.RowAnimation.automatic)
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return expandedList[indexPath.section] ? 80 : 0
        case 1:
            return expandedList[indexPath.section] ? 200 : 0
        default:
            return expandedList[indexPath.section] ? 250 : 0

        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactInformationTableViewCell.className, for: indexPath) as!
                ContactInformationTableViewCell
            cell.configureCell(email: email, phone: phone)
            cell.emailChanged = { str in
                self.email = str
            }
            cell.phoneChanged = { str in
                self.phone = str
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressInformationTableViewCell.className, for: indexPath) as!
                AddressInformationTableViewCell
            cell.configureCell(address: address, city: city, zip: zip, selectedState: selectedState)
            cell.addressChanged = { str in
                self.address = str
            }
            cell.cityChanged = { str in
                self.city = str
            }
            cell.zipChanged = { str in
                self.zip = str
            }
            cell.stateButtonTapped = {
                self.openStates(isBilling: false)
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShippingInformationTableViewCell.className, for: indexPath) as!
                ShippingInformationTableViewCell
            cell.configureCell(address: billingAddress, city: billingCity, zip: billingZip, selectedState: selectedBillingState)

            cell.addressChanged = { str in
                self.billingAddress = str
            }
            cell.cityChanged = { str in
                self.billingCity = str
            }
            cell.zipChanged = { str in
                self.billingZip = str
            }
            cell.stateButtonTapped = {
                self.openStates(isBilling: true)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
 
    //MARK:- Helper Methods
    private func openStates(isBilling: Bool) {   
        if statesArray.isEmpty {
            return
        }
        
        var strArray = [String]()
        statesArray.forEach { (model) in
            strArray.append(model.name ?? "")
        }
        
        Router.shared.openDataPickerPopUpVC(content: strArray, title: "Select State", selectedValue: strArray[0], controller: self.controller!, dataPickedHandler: { (index, value) in
            if let index = self.statesArray.lastIndex(where: {$0.name == value}) {
                if isBilling {
                    self.selectedBillingState = self.statesArray[index]
                } else {
                    self.selectedState = self.statesArray[index]
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func updateAPICall() {
        
        if email.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter email", action: {})
            return
        }
        
        if phone.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter phone number", action: {})
            return
        }
        if address.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter address", action: {})
            return
        }
        if city.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter city", action: {})
            return
        }
        if selectedState == nil {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please select state", action: {})
            return
        }
        if zip.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter postal code", action: {})
            return
        }
        if billingAddress.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter billing Address", action: {})
            return
        }
        if billingCity.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter billing city", action: {})
            return
        }
        if selectedBillingState == nil {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please select billing state", action: {})
            return
        }
        if billingZip.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "please enter billing postal code", action: {})
            return
        }
        
        
        
        let addressInfo = InformationModel(addressLine1: address, countryID: UnitedStatesId, stateID: selectedState?.id, stateIso2: selectedState?.iso2, city: city, zipCode: zip)
        let shipInfo = InformationModel(addressLine1: billingAddress, countryID: UnitedStatesId, stateID: selectedBillingState?.id, stateIso2: selectedBillingState?.iso2, city: billingCity, zipCode: billingZip)

        let requestModel = UpdateProfileRequestModel(email: email, cellCountryCode: "+1", cellPhoneNumber: phone, addressInformation: addressInfo, shippingInformation: shipInfo)
        sendVerificationCodeAPICall(updateProfileRequestModel: requestModel)
//        showProgressOnView()
//        HooleyPostAPIGeneric<UpdateProfileRequestModel, UpdateProfileResponseModel>.postRequest(apiURL: API.Account.updateprofile, requestModel: requestModel) { [weak self] (result) in
//            guard let `self`  = self else { return }
//            DispatchQueue.main.async {
//                self.hideProgressFromView()
//                switch result {
//                case .success(let responseModel):
//
//                    if responseModel.isError{
//                        self.controller?.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
//                    }else{
//                        self.controller?.alertMessage(title: K.SUCCESS, alertMessage: "Profile updated", action: {
//                            self.getcardholderprofile()
//                        })
//                    }
//
//                case .failure(let error):
//                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
//                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
//                }
//            }
//        }
    }
    
    private func sendVerificationCodeAPICall(updateProfileRequestModel: UpdateProfileRequestModel?) {
        let requestModel = SendVerificationCodeRequestModel()
        
        showProgressOnView()
        HooleyPostAPIGeneric<SendVerificationCodeRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.sendverificationcode, requestModel: requestModel) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.controller?.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        Router.shared.openUpdateProfileCodeViewController(delegateView: self, isViewDelegate: true, updateProfileRequestModel: updateProfileRequestModel, controller: self.controller!)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}

extension ProfileView {
    private func getStates() -> Void {
        
        showProgressOnView()
        
        let url = API.Common.getstates + "/\(UnitedStatesId)"
        HooleyAPIGeneric<GetStatesResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.statesArray = responseModel.data ?? []
                        self.getcardholderprofile()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func getcardholderprofile() -> Void {
        
        showProgressOnView()
        let url = API.Account.getcardholderprofile
        HooleyAPIGeneric<GetProfileHolderResponseModel>.fetchRequest(apiURL: url) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                
                switch result {
                case .success(let responseModel):
                    if responseModel.isError{
                        print(responseModel.messages ?? "")
                    }else{
                        self.profileModel = responseModel.data
                        if let model = self.profileModel {
                            
                            if let profile = ProfileDetails.instance.getProfileDetails() {
                                profile.email = model.email ?? ""
                                
                                profile.cellPhoneNumber = model.phone ?? ""
                                profile.addressLine1 = model.address1 ?? ""
                                profile.state = self.selectedState?.name ?? ""
                                profile.city = model.city ?? ""
                                profile.zipCode = model.postalCode ?? ""
                                
                                let shippingAddress = model.billingAddress1 ?? ""
                                let shippingCity = model.billingCity ?? ""
                                let shippingStateISO = model.billingStateCode ?? ""
                                
                                if shippingAddress.isEmpty {
                                    profile.shippingAddress1 = ""
                                } else {
                                    profile.shippingAddress1 = "\(shippingAddress), \(shippingCity), \(shippingStateISO), USA"
                                }

                                ProfileDetails.instance.saveProfileDetails(instance: profile)
                            }
                                  
                            if let index = self.statesArray.lastIndex(where: {$0.iso2 == model.stateCode}) {
                                self.selectedState = self.statesArray[index]
                            }
                            if let index = self.statesArray.lastIndex(where: {$0.iso2 == model.billingStateCode}) {
                                self.selectedBillingState = self.statesArray[index]
                            }
                            
                            self.email = model.email ?? ""
                            self.phone = model.cellNumber ?? ""
                            
                            self.city = model.city ?? ""
                            self.address = model.address1 ?? ""
                            self.zip = model.postalCode ?? ""
                            
                            self.billingCity = model.billingCity ?? ""
                            self.billingAddress = model.billingAddress1 ?? ""
                            self.billingZip = model.billingPostalCode ?? ""
                        }
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    func imageUploadApi(image: UIImage) {
        
        let img = image.fixImageOrientation()
        self.controller?.showProgressHud()
        let requestModel = MediaUploadRequestModel.init(type: MediaType.image.rawValue)
        
        let media = Media(withImage: img, forKey: K.MEDIA_FILE_KEY)
        HooleyPostMultipartAPIGeneric<MediaUploadRequestModel, MediaUploadResponseModel>.fetchRequest(apiURL: API.Upload.media, media: [media!], requestModel: requestModel) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let `self` = self else {return}
                self.controller?.hideProgressHud()
                
                switch result {
                case .success(let responseModel):
                    if let item = responseModel.data?.first {
                        if let profile = ProfileDetails.instance.getProfileDetails() {
                            profile.profileUrl = item.thumbURL ?? ""
                            ProfileDetails.instance.saveProfileDetails(instance: profile)
                        }
                        self.updateProfilePhotoAPICall(profileUrl: item.url ?? "", thumbnailUrl: item.thumbURL ?? "")
                    }
                    self.setup()
                    NotificationCenter.default.post(name: .REFRESH_PROFILE_PHOTO, object: nil)
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func updateProfilePhotoAPICall(profileUrl: String, thumbnailUrl: String) {

        let requestModel = UpdateProfilePictureRequestModel(profilePicture: profileUrl, profilePictureThumb: thumbnailUrl)
        
        showProgressOnView()
        HooleyPostAPIGeneric<UpdateProfilePictureRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.updateprofilepicture, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressFromView()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.controller?.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        print(responseModel)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.controller?.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}


extension HomeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerCustomViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.profileView.imageUploadApi(image: originalImage)
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
                        self.profileView.imageUploadApi(image: img)
                    }
                }
            }
        }
    }
}

extension ProfileView : UpdateProfileCodeViewControllerDelegate {
    func profileUpdated() {
        self.getcardholderprofile()
    }
}
