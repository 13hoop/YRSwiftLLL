source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def pods
	pod 'Alamofire','~> 3.0'
	pod 'AVOSCloud'        
	pod 'AVOSCloudIM'  
    pod 'Kingfisher','~> 2.0'
	pod 'RealmSwift'
end

target 'YRQuxinagtou' do
	pods	
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
		end
	end
end

