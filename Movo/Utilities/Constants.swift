//
//  Constants.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit

typealias EmptyCompletionHandler = (()->())


var isUserLogin : Bool {
    if let val = UserDefaults.standard.value(forKey: UserDefaultKeys.isUserLogin) as? Bool {
        return val
    }
    return false
}

var isBiometricLogin : Bool {
    if let val = UserDefaults.standard.value(forKey: UserDefaultKeys.iSBiometricLogin) as? Bool {
        return val
    }
    return false
}

let UnitedStatesId = 233

struct StandardLengths {
    static let US_PHONE = 11
    static let PAK_PHONE = 12
}

struct WebUrls {
//    static let depositHub = "https://movochain.com/deposithub"
//    static let moProSupport = "https://help.movo.cash"
//    static let termsConditions = "https://movo.cash/mobileapp/terms-and-conditions/"
//    static let privacyPolicy = "https://movo.cash/mobileapp/privacy-policy/"
//    static let cardHolderAgreement = "https://movo.cash/mobileapp/annual/"
   
    static let depositHub = "https://movo.cash/ccb-deposit-faq/"
    static let moProSupport = "https://movo.cash/ccb-mopro-support/"
    static let termsConditions = "https://movo.cash/ccb-digital-wallet-tcs/"
    static let privacyPolicy = "https://movo.cash/ccb-privacy/"
    static let cardHolderAgreement = "https://movo.cash/mobileapp/ccb-cardholder-agreement/"
    
    static let coastalCommunityPrivacyPolicy = "https://movo.cash/ccb-privacy-document/"
    static let movoPrivacyPolicy = "https://movo.cash/ccb-movo-privacy-pdf/"
}

struct MovoSdk {
    static let app_id = "movoSDK"
    static let client_key = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUNRd0RRWUpLb1pJaHZjTkFRRUJCUUFERXdBd0VBSUpBTHcxem1XcEVxaEpBZ01CQUFFPQotLS0tLUVORCBQVUJMSUMgS0VZLS0tLS0K"

}

struct Colors {
    static let BLACK = UIColor(named: "black")!
    static let LIGHT_WHITE = UIColor(named: "light_white_color")!
    static let WHITE = UIColor(named: "white")!
    static let LIGHT_GREY = UIColor(named: "light_gray")!
    static let SEPARATOR_COLOR = UIColor(named: "textfield_line_color")!
    static let APP_COLOR = #colorLiteral(red: 0.7098039216, green: 0.1921568627, blue: 0.2431372549, alpha: 1)

    static let PASSWORD_GRAY_COLOR = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    static let WHITE_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let GREY_COLOR = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
    static let DARK_GREY = #colorLiteral(red: 0.4235294118, green: 0.4235294118, blue: 0.4235294118, alpha: 1)
    static let BLACK_COLOR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let BORDER_COLOR = #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)

    static let BROWN_COLOR = #colorLiteral(red: 0.5176470588, green: 0.2196078431, blue: 0, alpha: 1)
    static let ORANGE_COLOR = #colorLiteral(red: 1, green: 0.4235294118, blue: 0, alpha: 1)
    static let GOLDEN_COLORS = #colorLiteral(red: 0.9725490196, green: 0.6274509804, blue: 0.1411764706, alpha: 1)
    static let YELLOW_COLOR = #colorLiteral(red: 0.9921568627, green: 0.768627451, blue: 0.2156862745, alpha: 1)
    static let LIGHT_YELLOW_COLOR = #colorLiteral(red: 1, green: 0.8274509804, blue: 0.4392156863, alpha: 1)
    static let CHARDON_COLOR = #colorLiteral(red: 1, green: 0.9215686275, blue: 0.8666666667, alpha: 1)
    static let BLUE_COLOR = #colorLiteral(red: 0.1098039216, green: 0.2274509804, blue: 0.462745098, alpha: 1)
    static let DASHBOARD_BACKGROUND_COLOR = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    static let GRAPH_YELLOW_COLOR = #colorLiteral(red: 1, green: 0.9803921569, blue: 0.9215686275, alpha: 1)

    static let TRANSACTION_REJECTED_COLOR = #colorLiteral(red: 0.9882352941, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
    static let RED_COLOR = #colorLiteral(red: 0.7098039216, green: 0.1921568627, blue: 0.2431372549, alpha: 1)
    static let LIGHT_RED_COLOR = #colorLiteral(red: 0.9882352941, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
    static let GREEN_COLOR = #colorLiteral(red: 0.1725490196, green: 0.7176470588, blue: 0.3882352941, alpha: 1)
    static let SKY_BLUE_COLOR = #colorLiteral(red: 0.3137254902, green: 0.9254901961, blue: 0.9333333333, alpha: 1)
    static let YELLOW_ORANGE_COLOR = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.5176470588, alpha: 1)
    static let DARK_YELLOW_COLOR = #colorLiteral(red: 1, green: 0.7647058824, blue: 0, alpha: 1)
    
}

var PLACEHOLDER_COLOR:UIColor {
    get {
        return #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.5960784314, alpha: 1)
    }
}


struct Storyboards {
    static let MAIN = UIStoryboard(name: "Main", bundle: nil)
    static let SIGNUP = UIStoryboard(name: "Signup", bundle: nil)
    static let POPUPS = UIStoryboard(name: "Popups", bundle: nil)
    static let HELPER = UIStoryboard(name: "Helper", bundle: nil)
}

struct Fonts {
    static let HELVETICA_BOLD_10 = UIFont(name: "Helvetica-Bold", size: 10)
    static let HELVETICA_BOLD_12 = UIFont(name: "Helvetica-Bold", size: 12)
    static let HELVETICA_BOLD_14  = UIFont(name: "Helvetica-Bold", size: 14)
    static let HELVETICA_BOLD_15 = UIFont(name: "Helvetica-Bold", size: 15)
    static let HELVETICA_BOLD_16 = UIFont(name: "Helvetica-Bold", size: 16)
    static let HELVETICA_BOLD_17 = UIFont(name: "Helvetica-Bold", size: 17)
    static let HELVETICA_BOLD_18 = UIFont(name: "Helvetica-Bold", size: 18)
    static let HELVETICA_BOLD_19 = UIFont(name: "Helvetica-Bold", size: 19)
    static let HELVETICA_BOLD_20 = UIFont(name: "Helvetica-Bold", size: 20)

    static let HELVETICA_REGULAR_12 = UIFont(name: "Helvetica", size: 12)
    static let HELVETICA_REGULAR_14 = UIFont(name: "Helvetica", size: 14)
    static let HELVETICA_REGULAR_15 = UIFont(name: "Helvetica", size: 15)
    static let HELVETICA_REGULAR_16 = UIFont(name: "Helvetica", size: 16)
    static let HELVETICA_REGULAR_17 = UIFont(name: "Helvetica", size: 17)
    static let HELVETICA_REGULAR_18 = UIFont(name: "Helvetica", size: 18)
    
    static let HELVETICA_LIGHT_15 = UIFont(name: "Helvetica-Light", size: 15)
    
    static let ALLER_REGULAR_12 = UIFont(name: "Aller", size: 12)
    static let ALLER_REGULAR_13 = UIFont(name: "Aller", size: 13)
    static let ALLER_REGULAR_14 = UIFont(name: "Aller", size: 14)
    static let ALLER_REGULAR_15 = UIFont(name: "Aller", size: 15)
    static let ALLER_REGULAR_16 = UIFont(name: "Aller", size: 16)
    static let ALLER_REGULAR_17 = UIFont(name: "Aller", size: 17)
    static let ALLER_REGULAR_18 = UIFont(name: "Aller", size: 18)
    static let ALLER_REGULAR_19 = UIFont(name: "Aller", size: 19)
    static let ALLER_REGULAR_20 = UIFont(name: "Aller", size: 20)
    static let ALLER_REGULAR_21 = UIFont(name: "Aller", size: 21)
    static let ALLER_REGULAR_22 = UIFont(name: "Aller", size: 22)

    static let ALLER_ITALIC_12 = UIFont(name: "Aller-Italic", size: 12)
    static let ALLER_ITALIC_13 = UIFont(name: "Aller-Italic", size: 13)
    static let ALLER_ITALIC_14 = UIFont(name: "Aller-Italic", size: 14)
    static let ALLER_ITALIC_15 = UIFont(name: "Aller-Italic", size: 15)
    static let ALLER_ITALIC_16 = UIFont(name: "Aller-Italic", size: 16)
    static let ALLER_ITALIC_17 = UIFont(name: "Aller-Italic", size: 17)
    
    static let ALLER_BOLD_10 = UIFont(name: "Aller-Bold", size: 10)
    static let ALLER_BOLD_12 = UIFont(name: "Aller-Bold", size: 12)
    static let ALLER_BOLD_13 = UIFont(name: "Aller-Bold", size: 13)
    static let ALLER_BOLD_14 = UIFont(name: "Aller-Bold", size: 14)
    static let ALLER_BOLD_15 = UIFont(name: "Aller-Bold", size: 15)
    static let ALLER_BOLD_16 = UIFont(name: "Aller-Bold", size: 16)
    static let ALLER_BOLD_17 = UIFont(name: "Aller-Bold", size: 17)
    static let ALLER_BOLD_18 = UIFont(name: "Aller-Bold", size: 18)
    static let ALLER_BOLD_19 = UIFont(name: "Aller-Bold", size: 19)

    static let ALLER_DISPLAY_12 = UIFont(name: "AllerDisplay", size: 12)
    static let ALLER_DISPLAY_13 = UIFont(name: "AllerDisplay", size: 13)
    static let ALLER_DISPLAY_14 = UIFont(name: "AllerDisplay", size: 14)
    static let ALLER_DISPLAY_15 = UIFont(name: "AllerDisplay", size: 15)
    static let ALLER_DISPLAY_16 = UIFont(name: "AllerDisplay", size: 16)
    static let ALLER_DISPLAY_17 = UIFont(name: "AllerDisplay", size: 17)
    
    static let ALLER_LIGHT_12 = UIFont(name: "Aller-Light", size: 12)
    static let ALLER_LIGHT_13 = UIFont(name: "Aller-Light", size: 13)
    static let ALLER_LIGHT_14 = UIFont(name: "Aller-Light", size: 14)
    static let ALLER_LIGHT_15 = UIFont(name: "Aller-Light", size: 15)
    static let ALLER_LIGHT_16 = UIFont(name: "Aller-Light", size: 16)
    static let ALLER_LIGHT_17 = UIFont(name: "Aller-Light", size: 17)
    
//    Aller
//    Aller
//    Aller-Italic
//    Aller-Bold
//    Aller-BoldItalic
//    Aller Display
//    AllerDisplay
//    Aller Light
//    Aller-Light
//    Aller-LightItalic
    
}

struct Icons {
    
    static let BACK_ARROW_BACK_ICON = UIImage(named: "back_arrow_black_icon")
    static let EMAIL_ICON = UIImage(named: "email_icon")
    
    static let TOUCH_ID_ICON = UIImage(named: "touchid_icon")
    static let FACE_ID_ICON = UIImage(named: "face_id_icon")


    static let POPUP_SELECTION_ICON = UIImage(named: "selected_popup_icon")
    static let POPUP_UNSELECTION_ICON = UIImage(named: "unselected_popup_icon")

    static let RECTANGLE_PLACEHOLDER = UIImage(named: "rectangle_placeholder")
    static let PROFILE_PLACEHOLDER = UIImage(named: "personal_detail_profile_icon")

    
    static let NOTIFICATION_BELL_ICON = UIImage(named: "bell_icon")
    static let PROFILE_PLACEHOLDER_IMAGE = UIImage(named: "profile_placeholder")
    static let BACK_ICON = UIImage(named: "back_icon")
    static let TITLE_IMAGE = UIImage(named: "title_image")
    
    static let MY_ADS_ICON = UIImage(named: "my_ads_icon")
    static let MY_SERVICES_ICON = UIImage(named: "my_services_icon")
    static let MY_SUBSCRIPTIONS_ICON = UIImage(named: "my_subscriptions_icon")
    static let FAVORITES_ICON = UIImage(named: "favorites_icon")
    static let MY_PROFILE_ICON = UIImage(named: "my_profile_icon")
    static let CITY_ICON = UIImage(named: "city_icon")
    static let LANGUAGE_ICON = UIImage(named: "language_icon")
    static let LOGOUT_ICON = UIImage(named: "logout_icon")
    static let EMAIL_VERIFITED_ICON = UIImage(named: "email_verified_icon")
    static let JPG_UPLOAD_IMG = UIImage(named: "jpg_upload_img")
    static let ARROW_DOWN_ICON = UIImage(named: "arrow_down_icon")
    static let ARROW_UP_ICON = UIImage(named: "arrow_up_icon")
    static let ARROW_RIGHT_ICON = UIImage(named: "arrow_right_icon")
    static let SIGNUP_ARROW_DOWN_ICON = UIImage(named: "signup_drop_down_icon")
    static let BANK_TO_CARD_ICON = UIImage(named: "bank_to_card_icon")!
    static let CARD_TO_BANK_ICON =  UIImage(named: "card_to_bank_icon")!
    static let INFO_ICON = UIImage(named: "info_icon")!
    
    static let EYE_ICON = UIImage(named: "eye_icon")
    static let SETTINGS_ICON = UIImage(named: "settings_icon")
    static let NEXT_ICON = UIImage(named: "next_icon")
    
    static let RADIO_BUTTON_SELECTED = UIImage(named: "radio_button_selected")
    static let RADIO_BUTTON_UNSELECTED = UIImage(named: "radio_button_unselected")
    static let PLUS_ICON = UIImage(named: "plus_icon")
    static let CHECK_BOX_UNSELECTED = UIImage(named: "check_box_unselected_icon")
    static let CHECK_BOX_SELECTED = UIImage(named: "check_box_selected_icon")
    
    static let CARD_STATUS_FAILED_ICON = UIImage(named: "movo_card_red_icon")
    static let CARD_STATUS_SUCCESS_ICON = UIImage(named: "movo_card_icon")

    struct DepositHub {
        static let DIRECT_DEPOSIT = UIImage(named: "direct_deposit_icon")!
        static let BANK_TO_CARD = UIImage(named: "bank_to_card_icon")!
        static let CASH_IN = UIImage(named: "cash_in_icon")!
        static let MOVO_CASH = UIImage(named: "movo_cash")!
        static let CHECK_DEPOSIT_ICON = UIImage(named: "check_deposit_icon")!
    }
    
        struct Home {
        static let MO_PRO_SELECTED = UIImage(named: "mo_pro_support_selected")!
        static let MO_PRO_UNSELECTED = UIImage(named: "mo_pro_support_un_selected")!
        static let CREDIT_SELECTED = UIImage(named: "movo_credit_selected")!
        static let CREDIT_UNSELECTED = UIImage(named: "movo_credit_un_selected")!
        static let TERMS_SELECTED = UIImage(named: "terms_selected")!
        static let TERMS_UNSELECTED = UIImage(named: "terms_un_selected")!
        static let PRIVACY_SELECTED = UIImage(named: "privacy_policy_selected")!
        static let PRIVACY_UNSELECTED = UIImage(named: "privacy_policy_un_selected")!
        static let CHANGE_PASSWORD_SELECTED = UIImage(named: "change_password_selected")!
        static let CHANGE_PASSWORD_UNSELECTED = UIImage(named: "change_password_un_selected")!
    }
    
    struct TransferIcons {
        static let SCHEDULED = UIImage(named: "transfer_scheduled_icon")!
        static let CANCELLED = UIImage(named: "transfer_cancelled_icon")!
        static let SUCCESS = UIImage(named: "transfer_success_icon")!
        static let FAILED = UIImage(named: "transfer_failed_icon")!
        static let IN_PROGRESS = UIImage(named: "transfer_inprogress_icon")!

    }
    
    struct SideMenu {
        
        struct MovoCash {
            static let ACCOUNTS = UIImage(named: "sidemenu_accouns")!
            static let ACCOUNTS_SUMMARY = UIImage(named: "sidemenu_account_summary")!
        }
        
        struct MovoPay {
            static let SEND_MONEY = UIImage(named: "sidemenu_send_money")!
            static let SOCIAL_MEDIA = UIImage(named: "sidemenu_social_media")!
            static let HISTORY = UIImage(named: "sidemenu_history")!
        }
        
        struct DigitalBanking {
            static let CASH_OUT_TO_BANK = UIImage(named: "sidemenu_cash_out_to_bank")!
            static let DIRECT_DEPOSIT = UIImage(named: "sidemenu_direct_deposit")!
            static let MY_BANK_ACCOUNTS = UIImage(named: "sidemenu_my_bank_accounts")!
            static let SCHEDULED_TRANSFERS = UIImage(named: "sidemenu_scheduled_transfers")!
            static let TRANSFER_ACTIVITY = UIImage(named: "sidemenu_transfer_activity")!
        }
        
        struct ECheckBook {
            static let MAKE_PAYMENTS = UIImage(named: "sidemenu_make_payment")!
            static let PAYMENT_HISTORY = UIImage(named: "sidemenu_payment_history")!
            static let ADD_PAYEES = UIImage(named: "sidemenu_add_payees")!
            static let MY_PAYEES = UIImage(named: "side_menu_my_payees")!
            static let SCHEDULED_PAYMENTS = UIImage(named: "sidemenu_schedule_payments")!
        }
        
        struct MyProfileSettings {
            static let PASSCODE = UIImage(named: "sidemenu_passcode")!
            static let MOVO_CASH_ALERTS = UIImage(named: "sidemenu_movo_cash_alerts")!
            static let BIOMETRIC_AUTHENTICATION = UIImage(named: "sidemenu_biometric_authentication")!
            static let MO_PRO_SUPPORT = UIImage(named: "sidemenu_mopro_support")!
            static let TERMS_CONDITION = UIImage(named: "sidemenu_terms_condition")!
            static let PRIVACY_POLICY = UIImage(named: "sidemenu_privacy_policy")!
            static let MANAGE_PROFILE = UIImage(named: "sidemenu_manage_profile")!
        }
        
        static let MOVO_CASH = UIImage(named: "movo_cash")!
        static let ACTIVATE_CARD = UIImage(named: "activate_card")!
        static let MOVO_PAY = UIImage(named: "movo_pay")!
        static let DEPOSIT_HUB = UIImage(named: "deposit_hub")!
        static let CASH_CARD = UIImage(named: "cash_card_atm")!
        static let DIGITAL_BANKING = UIImage(named: "digital_banking")!
        static let E_CHECKBOOK = UIImage(named: "e_checkbook")!
        static let MY_PROFILE_SETTINGS = UIImage(named: "myProfile_setting")!
        static let LOCK_UNLOCK_CARD = UIImage(named: "lock_unlock_card")!
        static let CHANGE_PASSWORD = UIImage(named: "change_Password")!
        static let ABOUT_US = UIImage(named: "about_us")!
        static let R_ICON = UIImage(named: "r_icon")!
    }

}

struct Alerts {
    static let EMPTY_PHONE_NUMBER = "Please Enter Phone Number."
    static let EMPTY_COUNTRY_CODE = "Please Enter Country Code."
    static let EMPTY_VERIFICATION_CODE = "Please Enter Valid Code."
    static let EMPTY_PASSWORD = "Please Enter Password."
    static let EMPTY_OLD_PASSWORD = "Please Enter old Password."
    static let EMPTY_NEW_PASSWORD = "Please Enter new Password."
    static let PASSWORD_NOT_MATCH = "Password not match."
    static let NUMBER_NOT_MATCH = "Phone Number not match."
    static let PASSWORD_LENGTH_VALIDATION = "Password Must Equal or Greater than 8 Characters."
    static let NUMBER_LENGTH_VALIDATION = "Please Enter Valid Number."
    static let EMPTY_NAME = "Please Enter Name."
    static let EMPTY_FIRST_NAME = "Please Enter First Name."
    static let EMPTY_LAST_NAME = "Please Enter Last Name."
    static let EMPTY_EMAIL_ADDRESS = "Please Enter Email."
    static let EMPTY_GENDER = "Please Enter Gender."
    static let EMPTY_DOB = "Please Enter date of birth."
    static let EMPTY_COUNTRY = "Please Select Country"
    static let EMPTY_CITY = "Please Select City"

    static let UPLOAD_MEDIA_ERROR = "Please Upload photo"
    static let UPLOAD_MEDIA_UPLOAD_WAIT_ERROR = "Wait, your media is still uploading..."
    static let CAMERA_NOT_SUPPORTED_TEXT = "Camera not supported"
    static let CAMERA_PRIVACY_SETTINGS_TEXT = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
    static let INVALID_CODE_PLEASE_ENTER_CODE_TEXT = "Invalid code. Please enter correct code"
    static let NOT_AVAILABLE_BALANCE = "The amount you are requesting to transfer is greater than your available balance."
    static let ERROR_INTERNET_UNAVAILABLE = "Internet connection appears to be offline. Please check your network settings."

    
}

extension Notification.Name {
    static let DISMISS_POPUP_VC = NSNotification.Name("DISMISS_POPUP_VC")
    static let DISMISS_TOUR = NSNotification.Name("DISMISS_TOUR")
    
    static let SIDE_MENU_OPTION_CLICKED = NSNotification.Name("SIDE_MENU_OPTION_CLICKED")
    static let RELOAD_HOME_SCREEN = NSNotification.Name("RELOAD_HOME_SCREEN")
    static let REFRESH_CASH_CARD_SCREEN = NSNotification.Name("REFRESH_CASH_CARD_SCREEN")
    static let REFRESH_MY_PAYEES_SCREEN = NSNotification.Name("REFRESH_MY_PAYEES_SCREEN")
    static let REFRESH_MY_BANK_ACCOUNT_SCREEN = NSNotification.Name("REFRESH_MY_BANK_ACCOUNT_SCREEN")
    static let REFRESH_SCHEDULED_TRANSFER_SCREEN = NSNotification.Name("REFRESH_SCHEDULED_TRANSFER_SCREEN")
    static let REFRESH_SCHEDULED_PAYMENT_SCREEN = NSNotification.Name("REFRESH_SCHEDULED_PAYMENT_SCREEN")
    static let REFRESH_CASH_ALERTS_SCREEN = NSNotification.Name("REFRESH_CASH_ALERTS_SCREEN")
    static let REFRESH_PROFILE_PHOTO = NSNotification.Name("REFRESH_PROFILE_PHOTO")

    static let appTimeout = Notification.Name("appTimeout")

}

struct DateFormats {
    static let yyyyMMdd = "yyyy/MM/dd"
    static let MMMMdyyyy = "MMMM d, yyyy"
    static let MMMddyyyy = "MMM dd, yyyy"
    static let MMyy = "MM/yy"
    static let EMMMdyyyy = "E, MMM d, yyyy"
    static let MMMdyyyy = "MMM d, yyyy"
    static let MMMd = "MMM d"
    static let dMMMMyyy = "d MMMM yyyy"
    static let mm_dd_yyyy = "MM-dd-yyyy"
    static let TIME_FORMAT = "h:mm a"
    static let DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss"
    static let MY_CARDS_DATE_FORMAT = "MMM dd, yyyy - hh:mm a"
    static let EN_US_POSIX = Locale(identifier: "en_US_POSIX")
    static let UTC_TIME_ZONE = TimeZone(abbreviation: "UTC")
}

struct K {
    static let MEDIA_FILE_KEY = "mediaFiles"
    static let LOADING_KEY = "loading..."
    static let ALERT = "Alert"
    static let LexixNexisResponse = "LexixNexisResponse"
    static let ERROR = "Error"
    static let SUCCESS = "Success"
    static let API_BASE_URL_TYPE = "APIBaseURLType"
    static let DEVICE_TOKEN = "deviceToken"
    static let CANCEL_TEXT = "Cancel"
    static let SETTINGS_TEXT = "Settings"
    static let kfcmToken = "fcmToken"
    static let USER_ID_KEY = "userId"
    static let IS_LOGIN_KEY = "isLogin"
    static let ERROR_KEY = "Error"
    static let PROFILE_PICTURE = "profilePicture"
    static let ROW = "row"
    static let SECTION = "section"
    static let MOVO = "movo"
}

struct ReloadHome {
    static let key = "homeReloadKey"
    
    struct ScreeenName {
        static let depositHub = "depositHubScreen"
        static let sendMoneny = "sendMoneyScreen"
        static let scheduleTransfer = "scheduleTransferScreen"
        static let makePayment = "makePayment"
    }
    
}

struct UserDefaultKeys {
    static let isUserLogin = "isUserLogin"
    static let isAccountVerified = "isAccountVerified"
    static let sessionId = "sessionId"
    static let sessionIdResponse = "sessionIdResponse"
    static let userPassword = "userPassword"
    static let userName = "userName"
    static let iSBiometricLogin = "iSBiometricLogin"
}

struct EncryptionKeys {
    static let profileDataKey = "profileDataKey"
}
