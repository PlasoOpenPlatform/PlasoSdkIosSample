# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source "https://cdn.cocoapods.org/"

target 'PlasoSdkDemoForiOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Material', '3.1.8'
  pod 'Eureka', '5.4.0'
  
  pod 'PlasoUpimeSdkModule', '1.53.302'
  pod 'PlasoStyleUpime', '1.53.302'
  
end

post_install do |installer|
  # https://stackoverflow.com/questions/37160688/set-deployment-target-for-cocoapodss-pod
  # 处理警告 The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 6.0, but the range of supported deployment target versions is 8.0 to 13.6.99.
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['CODE_SIGN_IDENTITY'] = '' #升级xcode14后，pod仓库需要sign，这边置空防止编译报错
    end
  end
end
