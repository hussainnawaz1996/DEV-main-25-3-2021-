//
//  PersonalDetailSecondTableViewController.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import UIKit
import AcuantHGLiveness
import AcuantiOSSDKV11
import AcuantCommon
import AcuantImagePreparation
import AVFoundation

protocol PersonalDetailSecondTableViewControllerDelegate: class {
    func secondScreenDismiss(model: CustomSignupModel?)
}

class PersonalDetailSecondTableViewController: UITableViewController {
    @IBOutlet var topButtons: [CircularSelectionButton]!

    @IBOutlet weak var frontImgContainer: RoundedPhotoView!
    @IBOutlet weak var backImgContainer: RoundedPhotoView!
    @IBOutlet weak var selfieImgContainer: CircularView!
    @IBOutlet weak var frontImageIcon: UIImageView!
    @IBOutlet weak var backImageIcon: UIImageView!
    @IBOutlet weak var selfieIcon: UIImageView!
    
    var customSignupModel:CustomSignupModel?
    var screen : PersonalDetailScreen?
    weak var delegate : PersonalDetailSecondTableViewControllerDelegate?

    private var isSelfieCamera = false
    private var isBackImageTaken = false
    private var frontImg : UIImage?
    private var backImg : UIImage?
    private var selfieImg : UIImage?
    
    private var isInitialized = false
    private let service: IAcuantTokenService = AcuantTokenService()

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.backgroundView = UIImageView(image: UIImage(named: "bg_icon"))
        updateDataFromModel()
        self.setBorders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isInitialized{
            self.getToken()
        }
    }
    
    private func validation() -> (msg: String, status: Bool) {
        
        if frontImg == nil {
            return ("Please upload front image", false)
        }
        
        if backImg == nil {
            return ("Please upload back image", false)
        }
        
        if selfieImg == nil {
            return ("Please upload selfie", false)
        }
        return("", true)
    }
    
    private func syncData() {
        customSignupModel?.photosModel?.frontImage = self.frontImg
        customSignupModel?.photosModel?.backImage = self.backImg
        customSignupModel?.photosModel?.selfieImage = self.selfieImg
    }
    
    private func updateDataFromModel() {
        if let model = customSignupModel {
            if let front = model.photosModel?.frontImage {
                self.frontImg = front
                self.frontImageIcon.image = front.fixImageOrientation()
                self.frontImageIcon.contentMode = .scaleAspectFill
            }
            if let back = model.photosModel?.backImage {
                self.backImg = back.fixImageOrientation()
                self.backImageIcon.image = back.fixImageOrientation()
                self.backImageIcon.contentMode = .scaleAspectFill
            }
            
            if let selfie = model.photosModel?.selfieImage {
                self.selfieImg = selfie.fixImageOrientation()
                self.selfieIcon.image = selfie.fixImageOrientation()
                self.selfieIcon.contentMode = .scaleAspectFill
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func continueButtonWasPressed(_ sender: BlackBGButton) {
        let result = validation()
        if result.status {
            syncData()
            verifyDocumentsAPICall()
        } else {
            alertMessage(title: K.ALERT, alertMessage: result.msg, action: nil)
        }
    }
    
    @IBAction func backButtonWasPreses(_ sender: UIButton) {
        syncData()
        navigationController?.popViewController(animated: true)
        delegate?.secondScreenDismiss(model: customSignupModel)
    }
    
    @IBAction func frontImageButtonWasPressed(_ sender: Any) {
        isSelfieCamera = false
        isBackImageTaken = false
//        openCameraWithPermision(type: .image, isFront: false, delegateController: self)
        self.handleInitialization()
    }
    
    @IBAction func backImageButtonWasPressed(_ sender: UIButton) {
        isSelfieCamera = false
        isBackImageTaken = true
//        openCameraWithPermision(type: .image, isFront: false, delegateController: self)
        
        self.handleInitialization()
    }
    
    @IBAction func selfieCameraButtonWasPressed(_ sender: UIButton) {
        isSelfieCamera = true
//        openCameraWithPermision(type: .image, isFront: true, delegateController: self)
        let liveFaceViewController = FaceLivenessCameraController()
        liveFaceViewController.delegate = self
        self.navigationController?.pushViewController(liveFaceViewController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}

extension PersonalDetailSecondTableViewController : AcuantHGLiveFaceCaptureDelegate, AcuantHGLivenessDelegate {
    func liveFaceCaptured(image: UIImage?) {
        DispatchQueue.main.async {
            if let img = image {
//                print(img.convertImageToBase64() as Any)
                self.getCroppedSelfie(image: img, originalImage: img)
            }
        }
    }
    
    func liveFaceDetailsCaptured(liveFaceDetails: LiveFaceDetails?, faceType: AcuantFaceType) {
        print("Face type is \(faceType)")
    }
    
}

extension PersonalDetailSecondTableViewController : CameraCaptureDelegate {
    func setCapturedImage(image: Image, barcodeString: String?) {
        DispatchQueue.main.async {
//            if let img = image.image {
//                self.openCropper(image: img)
//                self.setBorders()
//            }
//            if let data = image.data {
//                if let img = UIImage(data: data as Data) {
//                    self.openCropper(image: img)
//                    self.setBorders()
//                    self.nextButtonWasPressed(image: img, originalImage: img)
                    self.cropImage(image: image) { [weak self] croppedImage in
                        
                        guard let `self` = self else { return }
                        
                        if let img = croppedImage?.image {
                            self.nextButtonWasPressed(image: img, originalImage: img)
                            print(img.convertImageToBase64())
                        }
                    }
//                }
//            }
        }
    }
}

extension PersonalDetailSecondTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, DisplayCaptureImageViewControllerDelegate, CircularCropperViewControllerDelegate {
    
    private func setBorders() {
        
        if selfieImg != nil {
            selfieImgContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
        } else {
            selfieImgContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
        }
        
        if backImg != nil {
            backImgContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
        } else {
            backImgContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
        }
        
        if frontImg != nil {
            frontImgContainer.addBorder(withBorderColor: Colors.BLACK, borderWidth: 3.0)
        } else {
            frontImgContainer.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
        }
    }
    
    private func openCropper(image: UIImage) {
        Router.shared.openCropperViewController(image: image, controller: self)
    }
    
    private func openSelfieCropper(image: UIImage) {
        Router.shared.openSelfieCropper(image: image, controller: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: {
            let cropedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
            DispatchQueue.main.async {
                if var image = cropedImage {
                    image = image.fixImageOrientation()
                    if self.isSelfieCamera {
                        self.openSelfieCropper(image: image)
                    } else {
                        self.openCropper(image: image)
                    }
                    self.setBorders()
                }
            }
        })
    }
    
    func nextButtonWasPressed(image: UIImage, originalImage: UIImage) {
        DispatchQueue.main.async {
            if self.isBackImageTaken {
                self.backImg = image.fixImageOrientation()
                self.backImageIcon.image = image.fixImageOrientation()
                self.backImageIcon.contentMode = .scaleAspectFill
            } else {
                self.frontImg = image.fixImageOrientation()
                self.frontImageIcon.image = image.fixImageOrientation()
                self.frontImageIcon.contentMode = .scaleAspectFill
            }
//            print(image.convertImageToBase64() as Any)
            self.setBorders()
        }
    }
    
    func getCroppedSelfie(image: UIImage, originalImage: UIImage) {
        DispatchQueue.main.async {
            if self.isSelfieCamera {
                self.selfieImg = image.fixImageOrientation()
                self.selfieIcon.image = image.fixImageOrientation()
                self.selfieIcon.contentMode = .scaleAspectFill                
            }
            
            self.setBorders()
        }
    }
}

extension PersonalDetailSecondTableViewController {
    //MARK:- API Calls
    private func verifyDocumentsAPICall() {
        let sessionId = UserDefaults.standard.value(forKey: UserDefaultKeys.sessionId) as? String ?? ""
        
        var documentsArray = [DocumentModel]()
        var frontImgStr = ""
        var selfieImgStr = ""
        var backImgStr = ""
        
        if let img1 = self.frontImg {
            frontImgStr = img1.convertImageToBase64() ?? ""
        }
        
        if let img2 = self.selfieImg {
            selfieImgStr = img2.convertImageToBase64() ?? ""
        }
        if let img3 = self.backImg {
            backImgStr = img3.convertImageToBase64() ?? ""
        }
        documentsArray.append(DocumentModel(documentType: DocumentType.front.rawValue, base64: frontImgStr))
        documentsArray.append(DocumentModel(documentType: DocumentType.back.rawValue, base64: backImgStr))
        documentsArray.append(DocumentModel(documentType: DocumentType.selfie.rawValue, base64: selfieImgStr))

        let requestModel = VerifyDocumentRequestModel(sessionID: sessionId, documents: documentsArray)
        
        showProgressHud()
        HooleyPostAPIGeneric<VerifyDocumentRequestModel, BoolResponseModel>.postRequest(apiURL: API.Account.verifyDocuments, requestModel: requestModel) { [weak self] (result) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch result {
                case .success(let responseModel):
                    
                    if responseModel.isError{
                        self.alertMessage(title: K.ALERT, alertMessage: responseModel.messages ?? "", action: nil)
                    }else{
                        Router.shared.openPersonalDetailThirdTableViewController(controller: self, customSignupModel: self.customSignupModel)
                    }
                    
                case .failure(let error):
                    let err = CustomError(description: (error as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }

}

extension PersonalDetailSecondTableViewController : PersonalDetailThirdTableViewControllerDelegate {
    func thirdScreenDismiss(model: CustomSignupModel?) {
        self.customSignupModel = model
    }
}

extension PersonalDetailSecondTableViewController {
    private func getToken(){
        
        showProgressHud()
        let task = self.service.getTask() { [weak self] token in
            
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                self.hideProgressHud()
                
                if let success = token{
                    if Credential.setToken(token: success){
                        if(!self.isInitialized){
                            self.initialize()
                        } else {
                            self.alertMessage(title: K.ALERT, alertMessage: "Valid new Token", action: nil)
                        }
                    } else {
                        self.alertMessage(title: K.ALERT, alertMessage: "Invalid Token", action: nil)
                    }
                } else {
                    self.alertMessage(title: K.ALERT, alertMessage: "Failed to get Token", action: nil)
                }
            }
        }
        
        task?.resume()
    }
    
    private func initialize(){
        let initalizer: IAcuantInitializer = AcuantInitializer()
        let packages : Array<IAcuantPackage> = [AcuantImagePreparationPackage()]
        
        let task = initalizer.initialize(packages:packages) { [weak self]  error in
            
            DispatchQueue.main.async {
                if let self = self{
                    if(error == nil){
                        self.hideProgressHud()
                        self.isInitialized = true
                    } else {
                        self.hideProgressHud()
                        if let msg = error?.errorDescription {
                            self.alertMessage(title: K.ALERT, alertMessage: msg, action: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func handleInitialization(isDocumentCapture : Bool = true){
        if(ReachabilityTest.isConnectedToNetwork() == false){
            self.alertMessage(title: K.CANCEL_TEXT, alertMessage: Alerts.ERROR_INTERNET_UNAVAILABLE, action: nil)
        } else {
            let token = Credential.getToken()
            
            if(!self.isInitialized || (token != nil && !token!.isValid())){
                self.getToken()
                self.showProgressHud(title: "Initializing...")
            } else if isDocumentCapture {
                self.showDocumentCaptureCamera()
            } else {
                self.alertMessage(title: K.CANCEL_TEXT, alertMessage: "Need iOS 13 or later", action: nil)
            }
        }
    }
    
    private func cropImage(image:Image, callback: @escaping (AcuantImage?) -> ()){
        if image.image != nil {
            self.showProgressHud(title: "Processing...")
            
            DispatchQueue.global().async {
                AcuantImagePreparation.evaluateImage(data: CroppingData.newInstance(image: image)) {image,_ in
                    DispatchQueue.main.async {
                        self.hideProgressHud()
                        callback(image)
                    }
                }
            }
        }
    }
    
    private func showDocumentCaptureCamera(){
        AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
            guard let `self` = self else { return }
            if success {
                DispatchQueue.main.async {
                    let options = AcuantCameraOptions(digitsToShow: 2, autoCapture:true, hideNavigationBar: true)
                    let documentCameraController = DocumentCameraController.getCameraController(delegate:self, cameraOptions: options)
                    self.navigationController?.pushViewController(documentCameraController, animated: false)
                }
            } else {
                self.alertMessage(title: K.ALERT, alertMessage: "Camera access is absolutely necessary to use this app", action: nil)
            }
        }
    }
}
