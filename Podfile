# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Movo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Movo
  pod 'IQKeyboardManagerSwift'
  pod 'MBProgressHUD'
  pod 'SDWebImage'
  pod 'LGSideMenuController'
  pod 'ActiveLabel'
  pod 'UITextView+Placeholder'
  pod 'TOCropViewController'
  pod 'RNCryptor'
  pod 'AcuantiOSSDKV11'
  pod 'AcuantiOSSDKV11/AcuantImagePreparation'
  pod 'AcuantiOSSDKV11/AcuantCamera'
  
  post_install do |installer|
     installer.pods_project.targets.each do |target|
       if ['AcuantiOSSDKV11', 'KeychainAccess', 'Socket.IO-Client-Swift', 'Starscream' 'SwiftyJSON'].include? target.name
         target.build_configurations.each do |config|
           config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
         end
       end
     end
   end
  
end
