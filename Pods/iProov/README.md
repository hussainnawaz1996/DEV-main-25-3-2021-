# iProov iOS SDK v7.5.0

## 📖 Table of contents

- [Introduction](#-introduction)
- [Repository contents](#-repository-contents)
- [Upgrading from earlier versions](#-upgrading-from-earlier-versions)
- [Registration](#-registration)
- [Installation](#-installation)
- [Get started](#-get-started)
- [Options](#-options)
- [Localization](#-localization)
- [Handling failures & errors](#-handling-failures--errors)
- [Sample code](#-sample-code)
- [Help & support](#-help--support)

## 🤳 Introduction

The iProov iOS SDK enables you to integrate iProov into your iOS app. We also have an [Android SDK](https://github.com/iProov/android), [Xamarin bindings](https://github.com/iProov/xamarin) and [Web SDK](https://github.com/iProov/web).

### Requirements

- iOS 9.0 and above
- Xcode 11.0 and above

The framework has been written in Swift 5.2.4, and we recommend use of Swift for the simplest and cleanest integration, however it is also possible to call iProov from within an Objective-C app using our [Objective-C API](https://github.com/iProov/ios/wiki/Objective-C-Support), which provides an Objective-C friendly API to invoke the Swift code.

### Dependencies

The iProov SDK has dependencies on the following third-party frameworks:

- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

The SDK also utilises a [forked version](https://github.com/iproovopensource/GPUImage2) of [GPUImage2](https://github.com/BradLarson/GPUImage2) and includes a vendored copy of [Expression](https://github.com/nicklockwood/Expression).

### Module Stability

As of iProov SDK 7.2.0, module stability is supported for Swift 5.1 and above. The advantage of this is that the iProov SDK no longer needs to be recompiled for every new version of the Swift compiler.

iProov is built with the _"Build Libraries for Distribution"_ build setting enabled, which means that its dependencies must also be built in the same fashion. However, this is still not fully supported in either Cocoapods nor Carthage as of April 2020, therefore some workarounds are required (see installation documentation for details).

## 📦 Repository contents

The framework package is provided via this repository, which contains the following:

* **README.md** - This document!
* **WaterlooBank** - A sample project of iProov for the fictitious _"Waterloo Bank"_, written in Swift.
* **iProov.xcframework** - The iProov framework in XCFramework format. You can add this to your project manually if you aren't using a dependency manager.
* **iProov.framework** - The iProov framework as a "fat" dynamic framework for both device & simulator. (You can use this if you are unable to use the XCFramework version for whatever reason.)
* **iProov.podspec** - Required by Cocoapods. You do not need to do anything with this file.
* **resources** - Directory containing additional development resources you may find helpful.

## ⬆ Upgrading from earlier versions

If you're already using an older version of the iProov SDK, consult the [Upgrade Guide](https://github.com/iProov/ios/wiki/Upgrade-Guide) for detailed information about how to upgrade your app.

## ✍ Registration

You can obtain API credentials by registering on the [iProov Portal](https://portal.iproov.com/).

## 📲 Installation

Integration with your app is supported via both Cocoapods and Carthage. We recommend Cocoapods for the easiest installation.

### Cocoapods

As of iProov SDK 7.4.0 the framework is now distributed as an XCFramework, **you are therefore required to use Cocoapods 1.9.0 or newer**.

1. If you are not yet using Cocoapods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing Cocoapods, [click here](https://guides.cocoapods.org/using/getting-started.html#installation).)

2. Add the following to your Podfile (inside the target section):

	```ruby
	pod 'iProov'
	```
	
3. Add the following to the bottom of your Podfile:

	```ruby
	post_install do |installer|
	    installer.pods_project.targets.each do |target|
	      if ['iProov', 'KeychainAccess', 'Socket.IO-Client-Swift', 'Starscream' 'SwiftyJSON'].include? target.name
	        target.build_configurations.each do |config|
	            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
	        end
	      end
	    end
	end
	```
	
	> 🧰 **MODULE STABILITY WORKAROUND:** You must add this code, because whilst iProov (since 7.2.0) supports module stability, it is not directly supported in Cocoapods. This code will manually enable module stability for all of iProov's dependencies. [This is due to be fixed in Cocoapods 1.10.0](https://github.com/CocoaPods/CocoaPods/pull/9693).

4. Run `pod install`.

5. Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. “To iProov you in order to verify your identity.”)

### Carthage

Cocoapods is recommend for the easiest integration, however we also support Carthage. 
Full instructions installing and setting up Carthage [are available here](https://github.com/Carthage/Carthage).

At the time of writing, Carthage still does not properly support XCFrameworks, therefore it will install the traditional fat framework instead.

1. Add the following to your Cartfile:

	```
	github "socketio/socket.io-client-swift" == 15.2.0
	github "kishikawakatsumi/KeychainAccess" ~> 4.1
	github "SwiftyJSON/SwiftyJSON" ~> 5.0
	binary "https://raw.githubusercontent.com/iProov/ios/master/carthage/IProov.json"
	```

2. You can now build the dependencies with Carthage (see the note below about the custom build settings for module stability).

	```bash
	echo 'BUILD_LIBRARY_FOR_DISTRIBUTION=YES'>/tmp/iproov.xcconfig; XCODE_XCCONFIG_FILE=/tmp/iproov.xcconfig carthage build; rm /tmp/iproov.xcconfig
	```

	> 🧰 **MODULE STABILITY WORKAROUND:** iProov 7.2.0 supports module stability and therefore all its dependencies must be built in with the "Build Libraries for Distribution" setting enabled, however this is not currently supported in Carthage. Running this custom build command will ensure Xcode builds the dependencies with the correct settings. Once Carthage supports module stability, this workaround can be removed. Progress on this feature can be tracked [here](https://github.com/Carthage/Carthage/pull/2881).

3. Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (e.g. "To iProov you in order to verify your identity.")

## 🚀 Get started

Before being able to launch iProov, you need to get a token to iProov against. There are 2 different token types:

1. A **verify** token - for logging-in an existing user
2. An **enrol** token - for registering a new user

In a production app, you normally would want to obtain the token via a server-to-server back-end call. For the purposes of on-device demos/testing, we provide Swift/Alamofire sample code for obtaining tokens via [iProov API v2](https://secure.iproov.me/docs.html) with our open-source [iOS API Client](https://github.com/iProov/ios-api-client).

Once you have obtained the token, you can simply call `IProov.launch()`:

```swift
let token = "{{ your token here }}"

IProov.launch(token: token, callback: { (status) in

	switch status {
	case let .processing(progress, message):
		// The SDK will update your app with the progress of streaming to the server and authenticating
		// the user. This will be called multiple time as the progress updates.
	    
	case let .success(token):
		// The user was successfully verified/enrolled and the token has been validated.
		// The token passed back will be the same as the one passed in to the original call.
	    
	case let .failure(reason, feedbackCode):
		// The user was not successfully verified/enrolled, as their identity could not be verified,
		// or there was another issue with their verification/enrollment. A reason (as a string)
		// is provided as to why the claim failed, along with a feedback code from the back-end.
		
	case .cancelled:
		// The user cancelled iProov, either by pressing the close button at the top right, or sending
		// the app to the background.
	    
	case let .error(error):
		// The user was not successfully verified/enrolled due to an error (e.g. lost internet connection)
		// along with an `iProovError` with more information about the error (NSError in Objective-C).
		// It will be called once, or never.
		
	}
	
}
```

By default, iProov will stream to our EU back-end platform. If you wish to stream to a different back-end, you can pass a `streamingURL` as the first parameter to `IProov.launch()` with the base URL of the back-end to stream to.

> **⚠️ SECURITY NOTICE:** You should never use iProov as a local authentication method. You cannot rely on the fact that the success result was returned to prove that the user was authenticated or enrolled successfully (it is possible the iProov process could be manipulated locally by a malicious user). You can treat the success callback as a hint to your app to update the UI, etc. but you must always independently validate the token server-side (using the validate API call) before performing any authenticated user actions.

## ⚙ Options

You can customize the iProov session by passing in an `Options` object when launching iProov and setting any of these variables:

```swift
let options = Options()

/*
	UIOptions
	Configure options relating to the user interface
*/

options.ui.filter = .shaded // Adjust the filter used for the face preview. Can be .classic (as in pre-v7), .shaded (additional detail, the default in v7) or .vibrant (full color).

// Adjust various colors for the camera preview:
options.ui.lineColor = .white
options.ui.backgroundColor = .black
options.ui.loadingTintColor = .lightGray
options.ui.notReadyTintColor = .orange
options.ui.readyTintColor = .green

options.ui.title = "Authenticating to ACME Bank" // Specify a custom title to be shown. Defaults to nil which will show an iProov-generated message. Set to empty string ("") to hide the message entirely.
options.ui.font = "SomeFont" // You can specify your own font. This can either be a system font or a custom font in your app bundle (in which case don't forget to also add the font file to your Info.plist).
options.ui.logoImage = UIImage(named: "AcmeLogo") // A custom logo to be shown at the top-right of the iProov screen.
options.ui.scanLineDisabled = false // Disables the vertical sweeping scanline whilst flashing introduced in SDK v7.
options.ui.autoStartDisabled = false // Disable the "auto start" countdown functionality. The user will have to tap the screen to start iProoving.
options.ui.presentationDelegate = MyPresentationDelegate() // See the section below entitled "Custom IProovPresentationDelegate".
options.ui.stringsBundle = Bundle(for: Foo.class) // Pass a custom bundle for string localization (see Localization Guide for further information).

/*
	NetworkOptions
	Configure options relating to networking & security
*/

options.network.certificates = [Bundle.main.path(forResource: "custom_cert", ofType: "der")!] // Supply an array of paths of certificates to be used for pinning. Useful when using your own proxy server, or for overriding the built-in certificate pinning for some other reason. Certificates should be generated in DER-encoded X.509 certificate format, eg. with the command: $ openssl x509 -in cert.crt -outform der -out cert.der
options.network.certificatePinningDisabled = false	// Disables SSL/TLS certificate pinning to the server. WARNING! Do not enable this in production apps.
options.network.timeout = 10 // The network timeout in seconds.
options.network.path = "/socket.io/v2/" // The path to use when streaming, defaults to /socket.io/v2/. You should not need to change this unless directed to do so by iProov.

/*
	CaptureOptions
	Configure options relating to the capture functionality
*/

// You can specify max yaw/roll/pitch deviation of the user's face to ensure a given pose. Values are provided in normalised units.
// These options should not be set for general use. Please contact iProov for further information if you would like to use this feature.

options.capture.maxYaw = 0.03
options.capture.maxRoll = 0.03
options.capture.maxPitch = 0.03

```

### Custom `IProovPresentationDelegate`

By default, upon launching the SDK, it will get a reference to your app delegate's window's `rootViewController`, then iterate through the view controller stack to find the top-most view controller and then `present()` iProov's view controller as a modal view controller from the top-most view controller on the stack.

This may not always be the desirable behaviour; for instance, you may wish to present iProov as part of a `UINavigationController`-based flow. Therefore, it is also possible to set the `options.ui.presentationDelegate` property, which allows you to override the presentation/dismissal behaviour of the iProov view controller by conforming to the `IProovPresentationDelegate` protocol:

```swift
extension MyViewController: IProovPresentationDelegate {

    func present(iProovViewController: UIViewController) {
        // How should we present the iProov view controller?
    }

    func dismiss(iProovViewController: UIViewController) {
        // How should we dismiss the iProov view controller once it's done?
    }

}
```

> ⚠️ **IMPORTANT:** There are a couple of important rules you **must** follow when using this functionality:
> 
> 1. With great power comes great responsibility! The iProov view controller requires full cover of the entire screen in order to work properly. Do not attempt to present your view controller to the user in such a way that it only occupies part of the screen, or is obscured by other views. Also, you must ensure that the view controller is entirely removed from the user's view once dismissed.
> 
> 2. To avoid the risk of retain cycles, `Options` only holds a **weak** reference to your presentation delegate. Ensure that your presentation delegate is retained for the lifetime of the iProov capture session, or you may result in a defective flow.

## 🌎 Localization

The SDK ships with English strings only. If you wish to customise the strings in the app or localize them into a different language, see our [Localization Guide](https://github.com/iProov/ios/wiki/Localization).

## 💥 Handling failures & errors

### Failures

Failures occur when the user's identity could not be verified for some reason. A failure means that the capture was successfully received and processed by the server, which returned a result. Crucially, this differs from an error, where the capture itself failed due to a system failure.

Failures are caught via the `.failure(reason, feedbackCode)` enum case in the callback:

- `reason` - The reason that the user could not be verified/enrolled. You should present this to the user as it may provide an informative hint for the user to increase their chances of iProoving successfully next time

- `feedbackCode` - An internal representation of the failure code.

The current feedback codes and reasons are as follows:

| `feedbackCode` | `reason` |
|-----------------------------------|---------------------------------------------------------------|
| `ambiguous_outcome` | Sorry, ambiguous outcome |
| `network_problem` | Sorry, network problem |
| `motion_too_much_movement` | Please do not move while iProoving |
| `lighting_flash_reflection_too_low` | Ambient light too strong or screen brightness too low |
| `lighting_backlit` | Strong light source detected behind you |
| `lighting_too_dark` | Your environment appears too dark |
| `lighting_face_too_bright` | Too much light detected on your face |
| `motion_too_much_mouth_movement` | Please do not talk while iProoving |
| `user_timeout` | Sorry, your session has timed out |

The list of feedback codes and reasons is subject to change.

### Errors

Errors occur when the capture could not be completed due to a technical problem or user action which prevents the capture from completing.

Errors are caught via the `.error(error)` enum case in the callback. The `error` parameter provides the reason the iProov process failed as an `IProovError`.

A description of these cases are as follows:

* `captureAlreadyActive` - An existing iProov capture is already in progress. Wait until the current capture completes before starting a new one.
* `streamingError(String?)` - An error occurred with the video streaming process. Consult the error associated value for more information.
* `encoderError(code: Int32?)` - An error occurred with the video encoder. Report the error code to iProov for further assistance.
* `lightingModelError` - An error occurred with the lighting mode. This should be reported to iProov for further assistance.
* `cameraError(String?)` - An error occurred with the camera.
* `cameraPermissionDenied` - The user disallowed access to the camera when prompted. You should direct the user to re-enable camera access via Settings.
* `serverError(String?)` - A server-side error/token invalidation occurred. The associated string will contain further information about the error.

## 🏦 Sample code

For a simple iProov experience that is ready to run out-of-the-box, check out the [Waterloo Bank sample project](/tree/master/WaterlooBank).

### Installation

1. Ensure that you have [Cocoapods installed](https://guides.cocoapods.org/using/getting-started.html#installation) and then run `pod install` from the WaterlooBank directory to install the required dependencies.

2. Open `WaterlooBank.xcworkspace` then navigate to `HomeViewController.swift` and add your API key and Secret on the appropriate lines.

3. You can now build and run the project. Please note that you can only launch iProov on a real device; it will not work in the simulator.

> **⚠️ SECURITY NOTICE:** The Waterloo Bank sample project uses the [iOS API Client](https://github.com/iProov/ios-api-client) to directly fetch tokens on-device and this is inherently insecure. Production implementations of iProov should always obtain tokens securely from a server-to-server call.

## ❓ Help & support

You may find your question is answered in our [FAQs](https://github.com/iProov/ios/wiki/Frequently-Asked-Questions) or one of our other [Wiki pages](https://github.com/iProov/ios/wiki).

For further help with integrating the SDK, please contact [support@iproov.com](mailto:support@iproov.com).
