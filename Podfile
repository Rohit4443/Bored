# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bored' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bored
pod 'IQKeyboardManager'
pod 'GrowingTextView'
pod 'MultiSlider'
pod 'SVProgressHUD'
  pod 'Alamofire'
  pod 'Branch' 
pod 'BRYXBanner'
pod 'Kingfisher', '~> 7.0'
pod 'Koloda'
pod 'Socket.IO-Client-Swift', '~> 15.1.0'
pod 'GooglePlaces'
  pod 'GoogleMaps'
pod 'Swifter', :git => "https://github.com/mattdonnelly/Swifter.git"
post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
       end
     end
   end


end
