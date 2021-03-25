//
//  ENums.swift
//  Movo
//
//  Created by Ahmad on 26/10/2020.
//

import Foundation

enum OSType : String {
    case iOS = "iOS"
}

enum DeviceType : Int {
    case iOS = 2
}

enum PersonalDetailScreen {
    case first
    case second
    case third
}

enum cameraType {
    case image
    case video
}

enum GenderType : Int {
    case male = 1
    case female = 2
}

enum DocumentType : Int {
    case front = 1
    case back = 2
    case selfie = 3
}

enum MediaType : Int {
    case document = 1
    case image = 2
    case video = 3
}
enum CardType: Int {
    case mainCard = 0
    case purse = 1
    case supplementary = 2
    case sharedBalance = 3
}

//"MAINCARD" – For Main Card
//• "PURSE" – For Card Purse
//• "SUPPLEMENTARY" – For Supplementary Card
//• "SHAREDBALANCE" – For Shared Balance Card



enum SideMenuType : Int {
    case movoCash = 0
    case activateCard = 1
    case movoPay = 2
    case cashCard = 3
    case digitalBanking = 4
    case eCheckbook = 5
    case myProfile = 6
    case lockUnlock = 7
    case changePassword = 8
    case depositHub = 9
    case aboutUs = 10
}

enum SideMenuMovoCashType : Int {
    case accounts = 0
    case accountSummary = 1
}

enum SideMenuMovoPayType : Int {
    case sendMoney = 0
    case socialMedia = 1
    case history = 2
}

enum SideMenuDigitalBankingType : Int {
    case myBankAccounts = 0
    case cashOutToBank = 1
    case directDeposit = 2
    case scheduledTransfers = 3
    case transferActivity = 4
}

enum SideMenuECheckBookType : Int {
    case makePayment = 0
    case paymentHistory = 1
    case addPayees = 2
    case myPayees = 3
    case schedulePayments = 4
}

enum SideMenuProfileSettingType: Int {
    case manageProfile = 0
    case passcode = 1
    case movoCashAlerts = 2
    case biometricAuthentication = 3
    case moProSupport = 4
    case termsCondition = 5
    case privacyPolicy = 6
}

enum AccountType: Int {
    case cardToBank = 1
    case bankToCard = 2
}

enum FrequencyType: Int {
    case once = 1
    case date = 2
}

enum TransferStatus : String {
    case scheduled = "S"
    case failed = "F"
    case processed = "P"
    case cancelled = "C"
    case inProgress = "I"
    case deferred = "D"
    case success = "B"
    case logged = "L"
}

enum CardStatusIcon : String {
    case closed = "F"
    case inActive = "I"
}

enum PaymentStatus: String {
    case posted = "Posted"
    case logged = "Logged"
    case failed = "Failed"
    case sent = "Returned/Sent"
    case inprogress = "InProgress"
    case Canceled = "Canceled"
    case Scheduled = "Scheduled"
    case all = "All"
}

enum CashAlertOperator : Int {
    case greater = 1
    case less = 2
}

enum ServiceFeeType : Int {
    case UnloadCashCard = 0
    case ReloadCashCard = 1
    case ShareFunds = 2
    case GenerateCashCard = 3
    case PayToNonMov = 4
    case makePayment = 5
    case cardToBank = 6
}

//The status can be:
// P: Posted
// L: Logged
// F: Failed
// S: Returned/Sent
// I: InProgress
// A: All
