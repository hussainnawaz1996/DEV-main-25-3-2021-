//
//  Router.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit
import Photos

class Router {
    
    static let shared = Router()

    func openSigninTableViewController(controller:UIViewController) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: SigninTableViewController.className) as! SigninTableViewController
        control.addBackButtonOnly()
        controller.show(control, sender: nil)

    }
    
    func openPersonalDetailViewController(controller:UIViewController) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: PersonalDetailTableViewController.className) as! PersonalDetailTableViewController
        control.addBackButtonOnly()
        controller.show(control, sender: nil)

    }
    
    func openPersonalDetailSecondTableViewController(screen:PersonalDetailScreen? = nil, customSignupModel:CustomSignupModel?, controller:UIViewController) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: PersonalDetailSecondTableViewController.className) as! PersonalDetailSecondTableViewController
        control.addBackButtonOnly()
        control.delegate = controller.self as? PersonalDetailSecondTableViewControllerDelegate
        control.screen = screen
        control.customSignupModel = customSignupModel
        controller.show(control, sender: nil)

    }
    
    func openPersonalDetailThirdTableViewController(controller:UIViewController, customSignupModel:CustomSignupModel?) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: PersonalDetailThirdTableViewController.className) as! PersonalDetailThirdTableViewController
        control.addBackButtonOnly()
        control.delegate = controller.self as? PersonalDetailThirdTableViewControllerDelegate
        control.customSignupModel = customSignupModel
        controller.show(control, sender: nil)

    }
    
    func openSignupSuccessfullViewController(controller:UIViewController) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: SignupSuccessfullViewController.className) as! SignupSuccessfullViewController
        controller.show(control, sender: nil)

    }
    
    func openTransferActivityDetailViewController(model: TransferModel?, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: TransferActivityDetailViewController.className) as! TransferActivityDetailViewController
        control.model = model
        controller.show(control, sender: nil)

    }
    
    func openPaymentHistoryDetailViewController(controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: PaymentHistoryDetailViewController.className) as! PaymentHistoryDetailViewController
        controller.show(control, sender: nil)

    }
    
    func openAddPayeeViewController(requestModel:AddPayeeRequestModel? = nil, customModel:CustomAddPayeeModel? = nil, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: AddPayeeViewController.className) as! AddPayeeViewController
        control.requestModel = requestModel
        control.customModel = customModel
        controller.show(control, sender: nil)

    }
    
    func openCashCardTMDetailViewController(selectedCard: CardModel, primaryCard: CardModel?, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CashCardTMDetailViewController.className) as! CashCardTMDetailViewController
        control.selectedCard = selectedCard
        control.primaryCard = primaryCard
        controller.show(control, sender: nil)
    }
    
    func openPasscodeSettingsViewController(controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: PasscodeSettingsViewController.className) as! PasscodeSettingsViewController
        controller.show(control, sender: nil)
    }
    
    func openAddressBookViewController(controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: AddressBookViewController.className) as! AddressBookViewController
        control.delegate = (controller as? HomeViewController)?.sendMoneyEnterInfoView.self
        controller.show(control, sender: nil)
    }
    
    func openTransactionHistoryViewController(selectedCard: CardModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: TransactionHistoryViewController.className) as! TransactionHistoryViewController
        control.selectedCard = selectedCard
        controller.show(control, sender: nil)
    }
    
    func openEditMovoCashAlertsViewController(customModel: CustomCashAlertModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: EditMovoCashAlertsViewController.className) as! EditMovoCashAlertsViewController
        control.customModel = customModel
        controller.show(control, sender: nil)
    }
    
    func openCashCardTMEnterInfoViewController(selectedCard: CardModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CashCardTMEnterInfoViewController.className) as! CashCardTMEnterInfoViewController
        control.selectedCard = selectedCard
        controller.show(control, sender: nil)
    }
    
    func openCashCardTMReceiptViewController(selectedCard: CardModel?, requestModel: AddCashCardRequestModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CashCardTMReceiptViewController.className) as! CashCardTMReceiptViewController
        control.selectedCard = selectedCard
        control.requestModel = requestModel
        control.selectedCard = selectedCard
        controller.show(control, sender: nil)
    }
    
    func openReloadCashCardTMViewController(primaryCard: CardModel?, cashCard:CardModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: ReloadCashCardTMViewController.className) as! ReloadCashCardTMViewController
        control.primaryCard = primaryCard
        control.cashCard = cashCard
        controller.show(control, sender: nil)
    }
    
    func openReloadCashCardTMReceiptViewController(primaryCard: CardModel?, cashCard:CardModel?, requestModel: ReloadCashCardRequestModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: ReloadCashCardTMReceiptViewController.className) as! ReloadCashCardTMReceiptViewController
        control.primaryCard = primaryCard
        control.cashCard = cashCard
        control.requestModel = requestModel
        controller.show(control, sender: nil)
    }
    
    func openUnloadCashCardTMReceiptViewController(primaryCard: CardModel?, cashCard:CardModel?, controller: UIViewController)  -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: UnloadCashCardTMReceiptViewController.className) as! UnloadCashCardTMReceiptViewController
        control.primaryCard = primaryCard
        control.cashCard = cashCard
        controller.show(control, sender: nil)
    }
    
    func openBiometricLoginTableViewController(controller:UIViewController) -> Void {
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: BiometricLoginTableViewController.className) as! BiometricLoginTableViewController
        controller.show(control, sender: nil)
    }
    
    func openSendMoneyReceiptViewController(primaryCard: CardModel?, requestModel: ShareFundsRequestModel?, viewDelegate:UIView, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: SendMoneyReceiptViewController.className) as! SendMoneyReceiptViewController
        control.delegate = viewDelegate.self as? SendMoneyReceiptViewControllerDelegate
        control.primaryCard = primaryCard
        control.requestModel = requestModel
        controller.show(control, sender: nil)
    }
    
    
    func openMyBankAccountsTypeViewController(controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: MyBankAccountsTypeViewController.className) as! MyBankAccountsTypeViewController
        controller.show(control, sender: nil)
    }
    
    func openCreateNewBankAccountViewController(requestModel: CreateBankAccountRequestModel? = nil, accountType: AccountType, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CreateNewBankAccountViewController.className) as! CreateNewBankAccountViewController
        control.requestModel = requestModel
        control.selectedAccountType = accountType
        controller.show(control, sender: nil)
    }
    
    func openBankAccountReceiptViewController(requestModel: CreateBankAccountRequestModel, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: BankAccountReceiptViewController.className) as! BankAccountReceiptViewController
        control.requestModel = requestModel
        controller.show(control, sender: nil)
    }
    
    func openPayeeReceiptViewController(requestModel: AddPayeeRequestModel? = nil, selectedState: StateModel?, isSearchFlow: Bool = false, controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: PayeeReceiptViewController.className) as! PayeeReceiptViewController
        control.requestModel = requestModel
        control.selectedState = selectedState
        control.isSearchFlow = isSearchFlow
        controller.show(control, sender: nil)
    }
    
    func openDepositHubCashInDetailViewController( controller:UIViewController) -> Void {
        let control = Storyboards.HELPER.instantiateViewController(withIdentifier: DepositHubCashInDetailViewController.className) as! DepositHubCashInDetailViewController
        controller.show(control, sender: nil)
    }
    
    func openCardToBankReceiptViewController(requestModel: CashToBankTransferRequestModel?, selectedCard: CardModel?, selectedBank:AccountModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CardToBankReceiptViewController.className) as! CardToBankReceiptViewController
        control.requestModel = requestModel
        control.selectedCard = selectedCard
        control.selectedBank = selectedBank
        controller.show(control, sender: nil)
    }
    
    func openScheduledTransferReceiptViewController(model:TransferModel, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: ScheduledTransferReceiptViewController.className) as! ScheduledTransferReceiptViewController
        control.model = model
        controller.show(control, sender: nil)
    }
    
    func openEditScheduleBankTransferViewController(model:TransferModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: EditScheduleBankTransferViewController.className) as! EditScheduleBankTransferViewController
        control.transferModel = model
        controller.show(control, sender: nil)
    }
    
    func openMakePaymentReceiptViewController(isFromPayButton: Bool = false, requestModel:MakePaymentRequestModel?, customModel: CustomMakePaymentModel? = nil, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: MakePaymentReceiptViewController.className) as! MakePaymentReceiptViewController
        control.isFromPayButton = isFromPayButton
        control.requestModel = requestModel
        control.customModel = customModel
        controller.show(control, sender: nil)
    }
    
    func openSchedulePaymentReceiptViewController(requestModel:MakePaymentRequestModel?, customModel: CustomMakePaymentModel? = nil, isEditFlow: Bool, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: SchedulePaymentReceiptViewController.className) as! SchedulePaymentReceiptViewController
        control.requestModel = requestModel
        control.customModel = customModel
        control.isEditFlow = isEditFlow
        controller.show(control, sender: nil)
    }
    
    func openEditSchedulePaymentViewController(paymentModel:BillPaymentModel?, selectedCard:CardModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: EditSchedulePaymentViewController.className) as! EditSchedulePaymentViewController
        control.paymentModel = paymentModel
        control.selectedCard = selectedCard
        controller.show(control, sender: nil)
    }
    
    func openWebViewController(urlStr:String, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
        control.urlStr = urlStr
        controller.show(control, sender: nil)
    }
    
    func openMakePaymentFromExistingPayeeViewController(selectedPayee:PayeeModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.HELPER.instantiateViewController(withIdentifier: MakePaymentFromExistingPayeeViewController.className) as! MakePaymentFromExistingPayeeViewController
        control.selectedPayee = selectedPayee
        controller.show(control, sender: nil)
    }
    
    func openForgotPasswordUsernameViewController(controller:UIViewController) -> Void {
        
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: ForgotPasswordUsernameViewController.className) as! ForgotPasswordUsernameViewController
        control.addBackButtonOnly()
        controller.show(control, sender: nil)
    }
    
    func openNewCredentialsViewController(username: String, controller:UIViewController) -> Void {
        
        let control = Storyboards.SIGNUP.instantiateViewController(withIdentifier: NewCredentialsViewController.className) as! NewCredentialsViewController
        control.addBackButtonOnly()
        control.username = username
        controller.show(control, sender: nil)
    }

    func openCashCardEditNameViewController(selectedCard: CardModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: CashCardEditNameViewController.className) as! CashCardEditNameViewController
        control.selectedCard = selectedCard
        controller.show(control, sender: nil)
    }
    
    func openUpdateProfileCodeViewController(delegateView: UIView?, isViewDelegate: Bool, updateProfileRequestModel: UpdateProfileRequestModel?, controller:UIViewController) -> Void {
        
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: UpdateProfileCodeViewController.className) as! UpdateProfileCodeViewController
        control.updateProfileRequestModel = updateProfileRequestModel
        if isViewDelegate {
            control.delegate = delegateView.self as? UpdateProfileCodeViewControllerDelegate
        } else {
            control.delegate = controller.self as? UpdateProfileCodeViewControllerDelegate
        }
        controller.show(control, sender: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func openCopyOnClipboardPopupVC(controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: CopyOnClipboardPopupVC.className) as! CopyOnClipboardPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openCropperViewController(image:UIImage, controller:UIViewController) -> Void {
        let control = Storyboards.HELPER.instantiateViewController(withIdentifier: DisplayCaptureImageViewController.className) as! DisplayCaptureImageViewController
        control.delegate = controller.self as? DisplayCaptureImageViewControllerDelegate
        control.originalImage = image
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openSelfieCropper(image:UIImage, controller:UIViewController) -> Void {
        let control = Storyboards.HELPER.instantiateViewController(withIdentifier: CircularCropperViewController.className) as! CircularCropperViewController
        control.delegate = controller.self as? CircularCropperViewControllerDelegate
        control.originalImage = image
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    
                    
    func openGenericPopupVC(model:GenericPopupModelList, controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: GenericPopupVC.className) as! GenericPopupVC
        control.model = model
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openFromAccountAnAccountPopupVC( controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: FromAccountAnAccountPopupVC.className) as! FromAccountAnAccountPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openSelectTransferFrequencyPopupVC(delegateView: UIView?, isViewDelegate: Bool, controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: SelectTransferFrequencyPopupVC.className) as! SelectTransferFrequencyPopupVC
        if isViewDelegate {
            control.delegate = delegateView.self as? SelectTransferFrequencyPopupVCDelegate
        } else {
            control.delegate = controller.self as? SelectTransferFrequencyPopupVCDelegate
        }
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }

    func openNoBankAccountsPopupVC( controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: NoBankAccountsPopupVC.className) as! NoBankAccountsPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
                
    }
    
    func openSelectAccountPopupVC(delegateView: UIView?, isViewDelegate: Bool, isOnlyShowPrimaryAccounts: Bool = false, selectedCard: CardModel?, controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: SelectAccountPopupVC.className) as! SelectAccountPopupVC
        if isViewDelegate {
            control.delegate = delegateView.self as? SelectAccountPopupVCDelegate
        } else {
            control.delegate = controller.self as? SelectAccountPopupVCDelegate
        }
        control.isOnlyShowPrimaryAccounts = isOnlyShowPrimaryAccounts
        control.selectedCard = selectedCard
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
                
    }
    
    func openMakePaymentNoPayeePopupVC( controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: MakePaymentNoPayeePopupVC.className) as! MakePaymentNoPayeePopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
                
    }
    
    func openBankAccountInfoPopupVC( controller: UIViewController) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: BankAccountInfoPopupVC.className) as! BankAccountInfoPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
                
    }
    
    
    
    
    func openSetDateTimePopUPVC(title:String = "",
                                minumumDate:Date? = nil,
                                maximumDate:Date? = nil,
                                alreadySelectedDate:Date? = nil,
                                isDateOnly:Bool = false ,
                                controller:UIViewController,
                                completionHandler:@escaping DateSelectionCompletionHandler) -> Void {
        
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: SetDateTimePopUPVC.className) as! SetDateTimePopUPVC
        control.headingString = title
        control.alreadySelectedDate = alreadySelectedDate
        control.minumumDate = minumumDate
        control.maximumDate = maximumDate
        control.isDateOnly = isDateOnly
        control.doneButtonDidPressed = completionHandler
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
                
    }
    
    func openDataPickerPopUpVC(content:Array<String>,
                               title:String,
                               selectedValue:String,
                               controller:UIViewController,
                               dataPickedHandler:@escaping DataPickerCompletionHandler) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: DataPickerPopUpVC.className) as! DataPickerPopUpVC
        control.contentArray = content
        control.headingTitle = title
        control.selectedValue = selectedValue
        control.dataPickedHandler = dataPickedHandler
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
        
    }
    
    func openOrderPlasticCardPopupVC(controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: OrderPlasticCardPopupVC.className) as! OrderPlasticCardPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openDirectDepositFormPopupVC(controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: DirectDepositFormPopupVC.className) as! DirectDepositFormPopupVC
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openCashInPopupVC(delegateView:UIView, controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: CashInPopupVC.className) as! CashInPopupVC
        control.delegate = delegateView.self as? CashInPopupVCDelegate
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    func openCashDepositPopupVC(delegateView:UIView, controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: CashDepositPopupVC.className) as! CashDepositPopupVC
        control.delegate = delegateView.self as? CashDepositPopupVCDelegate
        controller.present(getNavigationController(controller: control), animated: true, completion: nil)
    }
    
    
    func openMenuOptionPopUpVC(options:[MenuOptions],isEnable:Bool = true,selectedOption:MenuOptions? = nil,controller:UIViewController,completionHandler:@escaping MenuOptionSelectionCompletionHandler) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: MenuOptionPopUpVC.className) as! MenuOptionPopUpVC
        control.options = options
        control.selectedOption = selectedOption
        control.selectionHandler = completionHandler
        control.isEnable = isEnable
        controller.presentPanModal(control)
        
    }
    
    func openImagePickerCustomViewController(mediaType : PHAssetMediaType = .image, controller:UIViewController) -> Void {
        let control = Storyboards.POPUPS.instantiateViewController(withIdentifier: ImagePickerCustomViewController.className) as! ImagePickerCustomViewController
        control.delegate = controller.self as? ImagePickerCustomViewControllerDelegate
        control.mediaType = mediaType
        control.modalPresentationStyle = .fullScreen
        controller.present(control, animated: true, completion: nil)
    }
    
    func getNavigationController(controller:UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.backgroundColor = UIColor.clear
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }
    
}
