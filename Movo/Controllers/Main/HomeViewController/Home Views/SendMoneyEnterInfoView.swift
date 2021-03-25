//
//  SendMoneyEnterInfoView.swift
//  Movo
//
//  Created by Ahmad on 02/11/2020.
//

import UIKit
import ContactsUI

class SendMoneyEnterInfoView: UIView, AddressBookViewControllerDelegate {

    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var commentsField: UITextField!
    var controller: UIViewController? = nil
    private var selectedCard : CardModel?

    func configureView(controller: UIViewController) {
        self.controller = controller
    }
    
    func setup() {
        if let cardModel = CardAccountModelInfoStruct.instance.fetchData(){
            
            let array  = cardModel.cards
            
            if let card = array?.filter({Common.shared.isPrimaryCard(model: $0)}).first {
                selectedCard = card
                setAccountDetail()
            }
        }
    }
    
    private func setAccountDetail() {
        balanceLbl.text = "$" + (selectedCard?.balance ?? "") + " USD"
        if let card = selectedCard {
            cardNumberLbl.text = Common.shared.getFormattedCardNumber(model: card)
        }

    }
    
    //MARK:- IBActions
    @IBAction func accountSelectButtonWasPressed(_ sender: UIButton) {
        Router.shared.openSelectAccountPopupVC(delegateView: self, isViewDelegate: true, isOnlyShowPrimaryAccounts: true, selectedCard: selectedCard, controller: controller!)
    }
    
    @IBAction func phoneButtonWasPressed(_ sender: UIButton) {
//        Router.shared.openAddressBookViewController(controller: controller!)
        openContactPicker()
        
    }
    
    func openContactPicker(){

        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self.controller as? CNContactPickerDelegate
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.controller?.present(contactPicker, animated: true, completion: nil)

    }
    
    func selectedContact(contact: UserContactModel) {
        contactField.text = contact.phoneNumber
    }
    
    func getSelectedContact(contactStr: String) {
        contactField.text = contactStr
    }
    
    func nextButtonWasPressed() {
        let amount = amountField.text ?? ""
        let contact = contactField.text ?? ""
        let amountVal = Double(amount) ?? 0.0
        let balanceVal = Double(selectedCard?.balance ?? "0.0") ?? 0.0

        if amount.isEmpty || amountVal == 0.0 {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "Please enter amount to send", action: nil)
            return
        }
        
        if amountVal > balanceVal {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: Alerts.NOT_AVAILABLE_BALANCE, action: nil)
            return
        }
        
        if contact.isEmpty {
            self.controller?.alertMessage(title: K.ALERT, alertMessage: "Please enter recipient", action: nil)
            return
        }
        
        let referenceId = selectedCard?.referenceID ?? ""
        let contactVal = contactField.text ?? ""
        let comments = commentsField.text ?? ""
        
        
        let requestModel = ShareFundsRequestModel(fromReferenceID: referenceId, amount: amountVal, toPhoneOrEmail: contactVal, comments: comments)
        
        Router.shared.openSendMoneyReceiptViewController(primaryCard: selectedCard, requestModel: requestModel, viewDelegate: self, controller: controller!)
    }
    
}

extension SendMoneyEnterInfoView : SelectAccountPopupVCDelegate, SendMoneyReceiptViewControllerDelegate {
    func getSelectedAccount(model: CardModel?) {
        selectedCard = model
        setAccountDetail()
    }
    
    func sendMoneySuccess() {
        resetData()
        
        var userInfo = [String: ReloadHomeModel]()
        let model = ReloadHomeModel(screen: ReloadHome.ScreeenName.sendMoneny, index: 0)
        userInfo = [ReloadHome.key : model]
        NotificationCenter.default.post(name: .RELOAD_HOME_SCREEN, object: nil, userInfo: userInfo)
        
    }
    
    private func resetData() {
        amountField.text = ""
        contactField.text = ""
        commentsField.text = ""
    }
}

extension HomeViewController : CNContactPickerDelegate {
    //MARK:- contact picker
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        let info = primaryPhoneNumberStr.getMSISDNFromString2()
        self.sendMoneyEnterInfoView.getSelectedContact(contactStr: info.phoneNumber ?? "")
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
