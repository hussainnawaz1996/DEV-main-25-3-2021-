//
//  HomeViewController+Extension.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

extension HomeViewController {
     
    func setupSubViews() {
        view.addSubview(maibButtonView)
        view.addSubview(accountsView)
        view.addSubview(sendMoneyNoRecordView)
        view.addSubview(profileView)
        view.addSubview(sendMoneyEnterInfoView)
        view.addSubview(accountSummaryView)
        view.addSubview(socialMediaView)
        view.addSubview(historyView)
        view.addSubview(activateCardView)
        view.addSubview(cashOutToBankView)
        view.addSubview(directDepositView)
        view.addSubview(myBankAccountsView)
        view.addSubview(scheduledTransfersView)
        view.addSubview(transferActivityView)
        view.addSubview(makePaymentView)
        view.addSubview(paymentHistoryView)
        view.addSubview(addPayeeView)
        view.addSubview(myPayeeView)
        view.addSubview(scheduledPaymentsView)
        view.addSubview(depositHubView)
        view.addSubview(cashCardTMView)
        view.addSubview(biometricAuthenticationView)
        view.addSubview(termsConditionView)
        view.addSubview(passcodeView)
        view.addSubview(movoCashAlertsView)
        view.addSubview(moProSupportView)
        view.addSubview(privacyPolicyView)
        view.addSubview(aboutUsView)
        view.addSubview(lockUnlockView)
        view.addSubview(changePasswordView)

        hideAllViews()
        accountsView.isHidden = false
        accountsView.setup()
        
        if let profile = ProfileDetails.instance.getProfileDetails() {
            titleLbl.text = profile.firstName + " " + profile.lastName
        }
                
        maibButtonView.configureView(controller: self)
        accountsView.configureView(controller: self)
        accountSummaryView.configureView(controller: self)
        sendMoneyNoRecordView.configureView(cardNumber: "", balance: "", controller: self)
        sendMoneyEnterInfoView.configureView(controller: self)
        profileView.configureView(controller: self)
        socialMediaView.configureView(controller: self)
        historyView.configureView(controller: self)
        activateCardView.configureView(controller: self)
        cashOutToBankView.configureView(controller: self)
        directDepositView.configureView(controller: self)
        myBankAccountsView.configureView(controller: self)
        scheduledTransfersView.configureView(controller: self)
        transferActivityView.configureView(controller: self)
        makePaymentView.configureView(controller: self)
        paymentHistoryView.configureView(controller: self)
        addPayeeView.configureView(controller: self)
        myPayeeView.configureView(controller: self)
        scheduledPaymentsView.configureView(controller: self)
        depositHubView.configureView(controller: self)
        cashCardTMView.configureView(controller: self)
        biometricAuthenticationView.configureView(controller: self)
        termsConditionView.configureView(controller: self)
        passcodeView.configureView(controller: self)
        movoCashAlertsView.configureView(controller: self)
        moProSupportView.configureView(controller: self)
        privacyPolicyView.configureView(controller: self)
        aboutUsView.configureView(controller: self)
        lockUnlockView.configureView(controller: self)
        changePasswordView.configureView(controller: self)
        
        sendMoneyNoRecordView.headerButtonTapped = {
            self.hideAllViews()
            self.sendMoneyEnterInfoView.isHidden = false
            self.sendMoneyEnterInfoView.setup()
            
            self.rightIcon.isHidden = true
            self.rightButton.setTitle("Send", for: .normal)

        }
    }
    
    func hideAllViews() {
        maibButtonView.isHidden = true
        accountsView.isHidden = true
        sendMoneyNoRecordView.isHidden = true
        profileView.isHidden = true
        sendMoneyEnterInfoView.isHidden = true
        accountSummaryView.isHidden = true
        socialMediaView.isHidden = true
        historyView.isHidden = true
        activateCardView.isHidden = true
        cashOutToBankView.isHidden = true
        directDepositView.isHidden = true
        myBankAccountsView.isHidden = true
        scheduledTransfersView.isHidden = true
        transferActivityView.isHidden = true
        makePaymentView.isHidden = true
        paymentHistoryView.isHidden = true
        addPayeeView.isHidden = true
        myPayeeView.isHidden = true
        scheduledPaymentsView.isHidden = true
        depositHubView.isHidden = true
        cashCardTMView.isHidden = true
        biometricAuthenticationView.isHidden = true
        termsConditionView.isHidden = true
        passcodeView.isHidden = true
        movoCashAlertsView.isHidden = true
        moProSupportView.isHidden = true
        privacyPolicyView.isHidden = true
        aboutUsView.isHidden = true
        lockUnlockView.isHidden = true
        changePasswordView.isHidden = true
    }
}
