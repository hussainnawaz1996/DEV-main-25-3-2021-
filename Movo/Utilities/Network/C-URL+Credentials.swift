//
//  C-URL+Credentials.swift
//  easypeasy
//
//  Created by EXIA on 07/10/2020.
//

import Foundation
//BASE_URL = "http://ec2-54-221-37-200.compute-1.amazonaws.com/api/"
struct BaseUrl {
    static var Testing = "http://ec2-54-221-37-200.compute-1.amazonaws.com"
    static var DEV = "https://devappapi.movo.cash"
    static var STAGING = ""
    static var LIVE = "https://appapi.movo.cash"
}

var apiURL : String {
    return "\(BaseUrl.DEV)/api"
}

struct API {
    struct Account {
        static let login = "\(apiURL)/Account/login"
        static let signup = "\(apiURL)/Account/signup"
        static let isUsernameExists = "\(apiURL)/Account/isusernameexists"
        static let isEmailExists = "\(apiURL)/Account/isemailexists"
        static let verifyDocuments = "\(apiURL)/Account/verifydocuments"
        static let createOTP = "\(apiURL)/Account/createotp"
        static let verifyOTP = "\(apiURL)/Account/verifyotp"
        static let logout = "\(apiURL)/Account/logout"
        static let updatepassword = "\(apiURL)/Account/updatepassword"
        static let getcardholderprofile = "\(apiURL)/Account/getcardholderprofile"
        static let updateprofile = "\(apiURL)/Account/updateprofile"
        static let forgotsentverificationcode = "\(apiURL)/Account/forgotsentverificationcode"
        static let changeforgotpasswordwithcode = "\(apiURL)/Account/changeforgotpasswordwithcode"
        static let getuseralerts = "\(apiURL)/Account/getuseralerts"
        static let addupdateuseralerts = "\(apiURL)/Account/addupdateuseralerts"
        static let updateprofilepicture = "\(apiURL)/Account/updateprofilepicture"
        static let sendverificationcode = "\(apiURL)/Account/sendverificationcode"
        static let iscodeverified = "\(apiURL)/Account/iscodeverified"

    }
    
    struct Common {
        static let getcountries = "\(apiURL)/common/getcountries"
        static let getstates = "\(apiURL)/common/getstates"
        static let getidentificationtypes = "\(apiURL)/common/getidentificationtypes"
        static let getSecretQuestions = "\(apiURL)/common/getsecretquestions"
        static let getservicefee = "\(apiURL)/common/getservicefee"

    }
    
    struct ECheckbook {
        static let addpayee = "\(apiURL)/ECheckbook/addpayee"
        static let getcardholderpayeelist = "\(apiURL)/ECheckbook/getcardholderpayeelist"
        static let editcardholderpayee = "\(apiURL)/ECheckbook/editcardholderpayee"
        static let deletecardholderpayee = "\(apiURL)/ECheckbook/deletecardholderpayee"
        static let searchpayee = "\(apiURL)/ECheckbook/searchpayee"
        static let makePayment = "\(apiURL)/ECheckbook/makepayment"
        static let getbillpaymenthistory = "\(apiURL)/ECheckbook/getbillpaymenthistory"
        static let cancelpayment = "\(apiURL)/ECheckbook/cancelpayment"
        static let editpayment = "\(apiURL)/ECheckbook/editpayment"

    }
        
    struct Card {
        static let getCardAccounts = "\(apiURL)/Card/getcardaccounts"
        static let getCardAuthData = "\(apiURL)/Card/getcardauthdata"
        static let miniStatementMultiAccounts = "\(apiURL)/Card/ministatementmultiaccounts"
        static let payHistory = "\(apiURL)/Card/payhistory"
        static let shareFunds = "\(apiURL)/Card/sharefunds"
        static let transactionHistory = "\(apiURL)/Card/transactionhistory"
        static let addCashCard = "\(apiURL)/Card/addcashcard"
        static let reloadCashCard = "\(apiURL)/Card/reloadcashcard"
        static let unloadCashCard = "\(apiURL)/Card/unloadcashcard"
        static let createbankaccount = "\(apiURL)/Card/createbankaccount"
        static let setcardstatus = "\(apiURL)/Card/setcardstatus"
        static let updatename = "\(apiURL)/Card/updatename"
        static let getsignontoken = "\(apiURL)/Card/getsignontoken"

    }
    
    struct Banking {
        static let createbankaccount = "\(apiURL)/Banking/createbankaccount"
        static let bankaccountslist = "\(apiURL)/Banking/bankaccountslist"
        static let removebankaccount = "\(apiURL)/Banking/removebankaccount"
        static let editbankaccount = "\(apiURL)/Banking/editbankaccount"
        static let c2btransfer = "\(apiURL)/Banking/c2btransfer"
        static let c2btransferlist = "\(apiURL)/Banking/c2btransferlist"
        static let c2btransfercancel = "\(apiURL)/Banking/c2btransfercancel"
        static let c2btransferupdate = "\(apiURL)/Banking/c2btransferupdate"

    }
    
    struct Upload {
        static let media = "\(apiURL)/Upload/multipleuploadmedias3"
    }
    

        
}

