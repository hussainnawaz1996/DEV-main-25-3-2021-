//
//  SocialAppOpen.swift
//  Movo
//
//  Created by Ahmad on 04/12/2020.
//

import UIKit

struct SocialNetworkUrl {
    let scheme: String
    let page: String

    func openPage() {
        let schemeUrl = URL(string: scheme)!
        if UIApplication.shared.canOpenURL(schemeUrl) {
            UIApplication.shared.openURL(schemeUrl)
        } else {
            UIApplication.shared.openURL(URL(string: page)!)
        }
    }
}

enum SocialNetwork {
    case Facebook, GooglePlus, Twitter, Instagram, youtube
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook:
//            https://www.facebook.com/movocash
            return SocialNetworkUrl(scheme: "fb://profile/579659758816833", page: "https://www.facebook.com/movocash")
//            return SocialNetworkUrl(scheme: "fb://profile/105684927870828", page: "https://www.facebook.com/movocashtransfer/?ref=page_internal")
        case .youtube:
            return SocialNetworkUrl(scheme: "youtube://xwf_SjjkbZU", page: "https://www.youtube.com/watch?v=xwf_SjjkbZU")
        default:
            return SocialNetworkUrl(scheme: "fb://profile/579659758816833", page: "https://www.facebook.com/movocash")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}

//let youtubeId = "xwf_SjjkbZU"
//var youtubeUrl = URL(string:"youtube://\(youtubeId)")!
//if UIApplication.shared.canOpenURL(youtubeUrl){
//    UIApplication.shared.openURL(youtubeUrl)
//} else{
//    youtubeUrl = URL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
//    UIApplication.shared.openURL(youtubeUrl)
//}
