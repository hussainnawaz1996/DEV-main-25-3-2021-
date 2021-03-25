//
//  HomeViewController.swift
//  Movo
//
//  Created by Ahmad on 29/10/2020.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var maibButtonView: MainButtonsView!
    @IBOutlet var accountsView: AccountsView!
    @IBOutlet var accountSummaryView: AccountSummaryView!
    @IBOutlet var sendMoneyNoRecordView: SendMoneyNoRecordView!
    @IBOutlet var sendMoneyEnterInfoView: SendMoneyEnterInfoView!
    @IBOutlet var profileView: ProfileView!
    @IBOutlet var socialMediaView: SocialMediaView!
    @IBOutlet var historyView: HistoryView!
    @IBOutlet var activateCardView: ActivateCardView!
    @IBOutlet var cashOutToBankView: CashOutToBankView!
    @IBOutlet var directDepositView: DirectDepositView!
    @IBOutlet var myBankAccountsView: MyBankAccountsView!
    @IBOutlet var scheduledTransfersView: ScheduledTransfersView!
    @IBOutlet var transferActivityView: TransferActivityView!
    @IBOutlet var makePaymentView: MakePaymentView!
    @IBOutlet var paymentHistoryView: PaymentHistoryView!
    @IBOutlet var addPayeeView: AddPayeeView!
    @IBOutlet var myPayeeView: MyPayeeView!
    @IBOutlet var scheduledPaymentsView: ScheduledPaymentsView!
    @IBOutlet var depositHubView: DepositHubView!
    @IBOutlet var cashCardTMView: CashCardTMView!
    @IBOutlet var biometricAuthenticationView: BiometricAuthenticationView!
    @IBOutlet var termsConditionView: TermsConditionView!
    @IBOutlet var passcodeView: PasscodeView!
    @IBOutlet var movoCashAlertsView: MovoCashAlertsView!
    @IBOutlet var moProSupportView: MoProSupportView!
    @IBOutlet var privacyPolicyView: PrivacyPolicyView!
    @IBOutlet var aboutUsView: AboutUsView!
    @IBOutlet var lockUnlockView: LockUnlockView!
    @IBOutlet var changePasswordView: ChangePasswordView!
    
    var currentItem : CurrentItem?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentItem = CurrentItem(row: -1, section: -1)
        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuOptionTapped(notification:)), name: .SIDE_MENU_OPTION_CLICKED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomeScreen(notification:)), name: .RELOAD_HOME_SCREEN, object: nil)
        setupSubViews()
        
        Common.shared.saveCardAccounts()
//        ContactsHelper.instance.syncLocalContacts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maibButtonView.frame = mainView.frame
        accountsView.frame = mainView.frame
        sendMoneyNoRecordView.frame = mainView.frame
        sendMoneyEnterInfoView.frame = mainView.frame
        profileView.frame = mainView.frame
        accountSummaryView.frame = mainView.frame
        socialMediaView.frame = mainView.frame
        historyView.frame = mainView.frame
        activateCardView.frame = mainView.frame
        cashOutToBankView.frame = mainView.frame
        directDepositView.frame = mainView.frame
        myBankAccountsView.frame = mainView.frame
        scheduledTransfersView.frame = mainView.frame
        transferActivityView.frame = mainView.frame
        makePaymentView.frame = mainView.frame
        paymentHistoryView.frame = mainView.frame
        addPayeeView.frame = mainView.frame
        myPayeeView.frame = mainView.frame
        scheduledPaymentsView.frame = mainView.frame
        depositHubView.frame = mainView.frame
        cashCardTMView.frame = mainView.frame
        biometricAuthenticationView.frame = mainView.frame
        termsConditionView.frame = mainView.frame
        passcodeView.frame = mainView.frame
        movoCashAlertsView.frame = mainView.frame
        moProSupportView.frame = mainView.frame
        privacyPolicyView.frame = mainView.frame
        aboutUsView.frame = mainView.frame
        lockUnlockView.frame = mainView.frame
        changePasswordView.frame = mainView.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return false
//    }

    @IBAction func openSideMenu(_ sender: Any) {
        showLeftViewAnimated(sender)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        rightButtonTapped()
    }
}
