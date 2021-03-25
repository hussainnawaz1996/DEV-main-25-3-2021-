//
//  HomeViewController+Sidemenu-Extension.swift
//  Movo
//
//  Created by Ahmad on 07/11/2020.
//

import UIKit

struct CurrentItem {
    var row : Int
    var section : Int
}

struct ReloadHomeModel {
    var screen: String
    var index : Int
}

enum DepositHubScreens : Int {
    case greenDotReload = 1
    case greenDotMoneyPack = 2
    case visaReadyLink = 3
    case siteDown = 4
    case appDownload = 5
    case stepsToDeposit = 6
}


extension HomeViewController {
    
    @objc func reloadHomeScreen(notification: Notification) {
        if let userInfo = notification.userInfo as? [String:ReloadHomeModel]{
            if let model = userInfo[ReloadHome.key] {
                
                self.hideAllViews()
                
                if model.screen == ReloadHome.ScreeenName.depositHub {
                    switch model.index {
                    case DepositHubScreens.siteDown.rawValue:
                        break
                    case DepositHubScreens.appDownload.rawValue:
                        break
                    default:
                        break
                    }
                } else if model.screen == ReloadHome.ScreeenName.sendMoneny {
                    self.accountsView.isHidden = false
                    self.accountsView.setup()
                    self.updateTitle(section: SideMenuType.movoCash.rawValue, row: 0)
                } else if model.screen == ReloadHome.ScreeenName.scheduleTransfer {
                    self.scheduledTransfersView.isHidden = false
                    self.scheduledTransfersView.setup()
                    self.updateTitle(section: SideMenuType.digitalBanking.rawValue, row:3)
                } else if model.screen == ReloadHome.ScreeenName.makePayment {
                    self.scheduledPaymentsView.isHidden = false
                    self.scheduledPaymentsView.setup()
                    self.updateTitle(section: SideMenuType.eCheckbook.rawValue, row:4)
                }
            }
        }
    }
    
    @objc func sideMenuOptionTapped(notification: Notification) {
        if let userInfo = notification.userInfo {
            let section = userInfo[K.SECTION] as? Int ?? 0
            let row = userInfo[K.ROW] as? Int ?? 0
            
            self.currentItem?.row = row
            self.currentItem?.section = section
            
            updateTitle(section: section, row: row)
            hideAllViews()
            
            if section == SideMenuType.movoCash.rawValue {
                if row == SideMenuMovoCashType.accounts.rawValue {
                    accountsView.isHidden = false
                    accountsView.setup()
                } else if row == SideMenuMovoCashType.accountSummary.rawValue{
                    accountSummaryView.isHidden = false
                    accountSummaryView.setupView()
                }
            } else if section == SideMenuType.activateCard.rawValue {
                activateCardView.isHidden = false
            } else if section == SideMenuType.movoPay.rawValue {
                if row == SideMenuMovoPayType.sendMoney.rawValue {
                    sendMoneyEnterInfoView.isHidden = false
                    sendMoneyEnterInfoView.setup()
                } else if row == SideMenuMovoPayType.socialMedia.rawValue {
                    socialMediaView.isHidden = false
                } else if row == SideMenuMovoPayType.history.rawValue  {
                    historyView.isHidden = false
                    historyView.setup()
                }
            } else if section == SideMenuType.depositHub.rawValue {
                depositHubView.isHidden = false
                depositHubView.setup()
            } else if section == SideMenuType.cashCard.rawValue {
                cashCardTMView.isHidden = false
                cashCardTMView.setup()
            } else if section == SideMenuType.digitalBanking.rawValue {
                if row == SideMenuDigitalBankingType.myBankAccounts.rawValue {
                    myBankAccountsView.isHidden = false
                    myBankAccountsView.setup()
                } else if row == SideMenuDigitalBankingType.cashOutToBank.rawValue {
                    cashOutToBankView.isHidden = false
                    cashOutToBankView.setup()
                } else if row == SideMenuDigitalBankingType.directDeposit.rawValue {
                    directDepositView.isHidden = false
                } else if row == SideMenuDigitalBankingType.scheduledTransfers.rawValue {
                    scheduledTransfersView.isHidden = false
                    scheduledTransfersView.setup()
                } else if row == SideMenuDigitalBankingType.transferActivity.rawValue {
                    transferActivityView.isHidden = false
                    transferActivityView.setup()
                }
            } else if section == SideMenuType.eCheckbook.rawValue {
                if row == SideMenuECheckBookType.makePayment.rawValue {
                    makePaymentView.isHidden = false
                    makePaymentView.setup()
                } else if row == SideMenuECheckBookType.paymentHistory.rawValue {
                    paymentHistoryView.isHidden = false
                    paymentHistoryView.setup()
                } else if row == SideMenuECheckBookType.addPayees.rawValue {
                    addPayeeView.isHidden = false
                    addPayeeView.setup()
                } else if row == SideMenuECheckBookType.myPayees.rawValue {
                    myPayeeView.isHidden = false
                    myPayeeView.setup()
                } else if row == SideMenuECheckBookType.schedulePayments.rawValue {
                    scheduledPaymentsView.isHidden = false
                    scheduledPaymentsView.setup()
                }
            } else if section == SideMenuType.myProfile.rawValue {
                if row == SideMenuProfileSettingType.passcode.rawValue {
                    passcodeView.isHidden = false
                } else if row == SideMenuProfileSettingType.movoCashAlerts.rawValue {
                    movoCashAlertsView.isHidden = false
                    movoCashAlertsView.setup()
                } else if row == SideMenuProfileSettingType.biometricAuthentication.rawValue {
                    biometricAuthenticationView.isHidden = false
                    biometricAuthenticationView.setup()
                } else if row == SideMenuProfileSettingType.moProSupport.rawValue {
                    moProSupportView.isHidden = false
                    moProSupportView.setup()
                } else if row == SideMenuProfileSettingType.termsCondition.rawValue {
                    termsConditionView.isHidden = false
                    termsConditionView.setup()
                } else if row == SideMenuProfileSettingType.privacyPolicy.rawValue {
                    privacyPolicyView.isHidden = false
                    privacyPolicyView.setup()
                } else if row == SideMenuProfileSettingType.manageProfile.rawValue {
                    profileView.isHidden = false
                    profileView.setup()
                } else {
                    
                }
            } else if section == SideMenuType.lockUnlock.rawValue {
                lockUnlockView.isHidden = false
                lockUnlockView.setup()
            } else if section == SideMenuType.changePassword.rawValue {
                changePasswordView.isHidden = false
                changePasswordView.setup()
            } else if section == SideMenuType.aboutUs.rawValue {
                aboutUsView.isHidden = false
            } else {
                
            }
        }
    }
    
    private func updateTitle(section:Int, row: Int) {
        
        subtitleLbl.isHidden = true
        rightView.alpha = 0
        rightIcon.isHidden = true
        rightButton.setTitle(nil, for: .normal)

        if section == SideMenuType.movoCash.rawValue {
            if row == SideMenuMovoCashType.accounts.rawValue {
                titleLbl.text = "Accounts"
            } else if row == SideMenuMovoCashType.accountSummary.rawValue {
                titleLbl.text = "Account Summary"
            }
        } else if section == SideMenuType.activateCard.rawValue {
            titleLbl.text = "Activate Card"
        } else if section == SideMenuType.movoPay.rawValue {
            if row == SideMenuMovoPayType.sendMoney.rawValue {
                rightView.alpha = 1
                rightIcon.isHidden = false
                rightIcon.image = Icons.NEXT_ICON
                titleLbl.text = "Send Money"
            } else if row == SideMenuMovoPayType.socialMedia.rawValue {
                titleLbl.text = "Social Media"
            } else if row == SideMenuMovoPayType.history.rawValue {
                titleLbl.text = "History"
            }
        } else if section == SideMenuType.depositHub.rawValue {
            titleLbl.text = "Deposit Hub"
        } else if section == SideMenuType.cashCard.rawValue {
            titleLbl.setAttributedTextWithSubscripts(str: "CASH Card", superScript: "®")
            rightView.alpha = 1
            rightIcon.isHidden = false
            rightIcon.image = Icons.PLUS_ICON
        } else if section == SideMenuType.digitalBanking.rawValue {
            if row == SideMenuDigitalBankingType.myBankAccounts.rawValue {
                rightView.alpha = 1
                rightButton.setTitle("Add", for: .normal)
                titleLbl.text = "My Bank Accounts"
            } else if row == SideMenuDigitalBankingType.cashOutToBank.rawValue {
                rightView.alpha = 1
                rightIcon.isHidden = false
                rightIcon.image = Icons.NEXT_ICON
                titleLbl.text = "Cash Out To Bank"
            } else if row == SideMenuDigitalBankingType.directDeposit.rawValue {
                titleLbl.text = "Direct Deposit"
            } else if row == SideMenuDigitalBankingType.scheduledTransfers.rawValue {
                titleLbl.text = "Scheduled Transfers"
            } else if row == SideMenuDigitalBankingType.transferActivity.rawValue {
                titleLbl.text = "Transfer Activity"
                subtitleLbl.isHidden = false
                subtitleLbl.text = "(Last Six Months)"
            }
        } else if section == SideMenuType.eCheckbook.rawValue {
            if row == SideMenuECheckBookType.makePayment.rawValue {
                rightView.alpha = 1
                rightIcon.isHidden = false
                rightIcon.image = Icons.NEXT_ICON
                titleLbl.text = "Make Payment"
            } else if row == SideMenuECheckBookType.paymentHistory.rawValue {
                titleLbl.text = "Payment History"
                subtitleLbl.isHidden = false
                subtitleLbl.text = "(Last Six Months)"
            } else if row == SideMenuECheckBookType.addPayees.rawValue {
                rightView.alpha = 1
                titleLbl.text = "Add Payee"
                rightButton.setTitle("Custom Payee", for: .normal)
            } else if row == SideMenuECheckBookType.myPayees.rawValue {
                titleLbl.text = "My Payee"
            } else  if row == SideMenuECheckBookType.schedulePayments.rawValue {
                titleLbl.text = "Scheduled Payments"
            }
        } else if section == SideMenuType.myProfile.rawValue {
            if row == SideMenuProfileSettingType.passcode.rawValue {
                rightView.alpha = 0
                titleLbl.text = "Passcode"
            } else if row == SideMenuProfileSettingType.movoCashAlerts.rawValue {
                titleLbl.setAttributedTextWithSubscripts(str: "Movo^{®} Cash Alerts")
            } else if row == SideMenuProfileSettingType.biometricAuthentication.rawValue {
                titleLbl.text = "Biometric Authentication"
            } else if row == SideMenuProfileSettingType.moProSupport.rawValue {
                titleLbl.text = "MoPro Support"
            } else if row == SideMenuProfileSettingType.termsCondition.rawValue {
                rightView.alpha = 0
                titleLbl.text = "Terms & Conditions"
            } else if row == SideMenuProfileSettingType.privacyPolicy.rawValue {
                rightView.alpha = 0
                titleLbl.text = "Privacy Policy"
            } else if row == SideMenuProfileSettingType.manageProfile.rawValue {
                rightView.alpha = 1
                rightButton.setTitle("Update", for: .normal)
                titleLbl.text = "Profile"
            }
        } else if section == SideMenuType.lockUnlock.rawValue {
            rightView.alpha = 0
            titleLbl.text = "Lock/Unlock Card"
        } else if section == SideMenuType.changePassword.rawValue {
            titleLbl.text = "Change Password"
            rightView.alpha = 1
            rightButton.setTitle("Change", for: .normal)
        } else if section == SideMenuType.aboutUs.rawValue {
            titleLbl.text = "About Us"
        } else {
            
        }
    }
    
    func rightButtonTapped() {
        let section = self.currentItem?.section ?? 0
        let row = self.currentItem?.row ?? 0
        
        if section == SideMenuType.movoPay.rawValue {
            if row == SideMenuMovoPayType.sendMoney.rawValue {
                self.sendMoneyEnterInfoView.nextButtonWasPressed()
            }
        } else if section == SideMenuType.cashCard.rawValue {
            cashCardTMView.openCashCardEnterInfoScreen()
        } else if section == SideMenuType.digitalBanking.rawValue {
            if row == SideMenuDigitalBankingType.myBankAccounts.rawValue {
                Router.shared.openMyBankAccountsTypeViewController(controller: self)
            }
            if row == SideMenuDigitalBankingType.cashOutToBank.rawValue {
                cashOutToBankView.nextButtonWasPressed()
            }
        } else if section == SideMenuType.eCheckbook.rawValue {
            if row == SideMenuECheckBookType.makePayment.rawValue {
                makePaymentView.nextButtonWasPressed()
            }
            if row == SideMenuECheckBookType.addPayees.rawValue {
                Router.shared.openAddPayeeViewController(controller: self)
            }
        } else if section == SideMenuType.changePassword.rawValue {
            changePasswordView.changeButtonWasPressed()
        } else if section == SideMenuType.myProfile.rawValue {
            profileView.updateAPICall()
        }
    }
}
