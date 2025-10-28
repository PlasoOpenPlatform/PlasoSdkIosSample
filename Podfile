# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

source "https://cdn.cocoapods.org/"
source  'https://github.com/PlasoOpenPlatform/plaso-open-specs.git'

target 'PlasoSdkDemoForiOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :dynamic
  
  pod 'Material', '3.1.8'
  pod 'Eureka', '5.4.0'
  pod 'Alamofire'
  
  pod 'PlasoStyleUpime', '1.60.121'
  pod 'PlasoUpimeSdkModule', '1.60.121'
  pod 'PlasoProgressHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
