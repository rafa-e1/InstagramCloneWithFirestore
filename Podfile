# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Instagram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Instagram
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'JGProgressHUD'
  pod 'SDWebImage', '~> 5.0'
  pod 'ActiveLabel'
  pod 'YPImagePicker'
  pod 'SnapKit', '~> 5.7.0'
  pod 'Then'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end
