# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'QLOGA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'GoogleMaps', '6.0.1'
  pod 'GooglePlaces'
  pod 'BottomSheetSwiftUI', :git => 'https://github.com/DM1TRYM/BottomSheet.git', :branch => 'master'
  pod 'CalendarKit', :git => 'https://github.com/DM1TRYM/CalendarKit.git', :branch => 'master'
  pod 'StepperView','~> 1.6.7'
  # Pods for QLOGA

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
