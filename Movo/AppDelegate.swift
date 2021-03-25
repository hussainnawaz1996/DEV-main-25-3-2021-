//
//  AppDelegate.swift
//  Movo
//
//  Created by Ahmad on 25/10/2020.
//

import UIKit
import IQKeyboardManagerSwift
import TMXProfilingConnections
import TMXProfiling
import MCPSDK

//@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var profile: TMXProfiling!
    var loginOkay: Bool = false
    var profileTimeout: TimeInterval = 20;
    var sessionID: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        NotificationCenter.default.addObserver(self,
                                   selector: #selector(AppDelegate.applicationDidTimeout(notification:)),
                                   name: .appTimeout,
                                   object: nil)

        UIApplication.shared.statusBarView?.backgroundColor = Colors.APP_COLOR
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        MCPSDKManager.initSDK(MovoSdk.app_id, apiKey: MovoSdk.client_key)
        
        let config = UIConfiguration()
        config.hideBackButton = false
        config.hideNavigationbar = false
        config.navBarBGColor = UIColor.red
        config.navBarTextColor = UIColor.white
        config.loadingOption = LOAD_ON_SCREEN
        MCPSDKManager.setUIConfiguration(config)

        
        performProfiling()
        return true
    }
    
    func performProfiling() {
        initializeProfiling()
        perform(#selector(doProfile), with: nil, afterDelay: 2.0)
    }

//    func enableIdleTimer() {
//        timerApp.enableTimer()
//    }
//    
//    func disableIdleTimer() {
//        timerApp.disableTimer()
//    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @objc func applicationDidTimeout(notification: NSNotification) {
        print("application did timeout, perform actions")
        if isUserLogin {
            if let topVC = UIApplication.shared.visibleViewController {
                topVC.alertMessage(title: K.ALERT, alertMessage: "Session Expired") {
                    UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isUserLogin)
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        delegate.performProfiling()
                    }
                    ModeSelection.instance.signupMode()
                }
            }
        }
    }

    //MARK:- Profiling
    func initializeProfiling() {
        let profilingConnections: TMXProfilingConnections  = TMXProfilingConnections.init()
        profilingConnections.connectionTimeout    = 20; // Default value is 10 seconds
        profilingConnections.connectionRetryCount = 2;  // Default value is 0 (no retry)
        //Get a singleton instance of TrustDefenderMobile
        profile = TMXProfiling.sharedInstance()
        // The profile.configure method is effective only once and subsequent calls to it will be ignored.
        // Please note that configure may throw NSException if NSDictionary key/value(s) are invalid.
        // This only happen due to programming error, therefore we don't catch the exception to make sure there is no error in our configuration dictionary
        profile?.configure(configData:[
            // (REQUIRED) Organisation ID
            TMXOrgID              :"316ivgf0",
            // (REQUIRED) Enhanced fingerprint server
//            TMXFingerprintServer  :"enhanced-fp-server",
            // (OPTIONAL) Set the profile timeout, in seconds
            //                            TMXProfileTimeout     : profileTimeout,
            // (OPTIONAL) If Keychain Access sharing groups are used, specify like this
//            TMXKeychainAccessGroup: "<TEAM_ID>.<BUNDLE_ID>",
            // (OPTIONAL) Register for location service updates.
            // Requires permission to access device location
//            TMXLocationServices   : true,
            // (OPTIONAL) Pass the configured instance of TMXProfilingConnections to TMX SDK.
            // If not passed, configure method tries to create and instance of TMXProfilingConnections
            // with the default settings.
            TMXProfilingConnectionsInstance:profilingConnections,
        ])
    }
    
    @objc func doProfile()
    {
        let customAttributes : [String : Array<String>] = [TMXCustomAttributes: ["attribute 1", "attribute 2"]]
        loginOkay = false
        // Fire off the profiling request.
        let profileHandle: TMXProfileHandle = profile.profileDevice(profileOptions:customAttributes, callbackBlock:{(result: [AnyHashable : Any]?) -> Void in
            let results:NSDictionary! = result! as NSDictionary
            let status:TMXStatusCode  = TMXStatusCode(rawValue:(results.value(forKey: TMXProfileStatus) as! NSNumber).intValue)!
            self.sessionID = results.value(forKey: TMXSessionID) as? String
            if(status == .ok)
            {
                // No errors, profiling succeeded!
            }
            let statusString: String =
                status == .ok                  ? "OK"                   :
                status == .networkTimeoutError ? "Timed out"            :
                status == .connectionError     ? "Connection Error"     :
                status == .hostNotFoundError   ? "Host Not Found Error" :
                status == .internalError       ? "Internal Error"       :
                status == .interruptedError    ? "Interrupted Error"    :
                "Other"
//            print("Profile completed with: \(statusString) and session ID: \(self.sessionID ?? "")")
            UserDefaults.standard.setValue(self.sessionID, forKey: UserDefaultKeys.sessionId)
            UserDefaults.standard.setValue(statusString, forKey: UserDefaultKeys.sessionIdResponse)

            self.loginOkay = true
        })
        // Session id can be collected here (to use in API call (AKA session query))
        self.sessionID = profileHandle.sessionID;
        print("Session id is \(self.sessionID ?? "")");
        /*
         * profileHandle can also be used to cancel this profile if needed
         *
         * profileHandle.cancel()
         * */
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 5111
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                
                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}

extension UIApplication {
    var visibleViewController : UIViewController? {
        return windows.first?.rootViewController?.topMostViewController
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
