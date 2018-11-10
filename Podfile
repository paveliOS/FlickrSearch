# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

target 'FlickrSearch' do
    pod 'Kingfisher', '~> 4.10'
    pod 'Alamofire', '~> 4.7'
    pod 'Diff', :git => 'https://github.com/wokalski/Diff.swift', :branch => 'swift-4.0'
    pod 'SKPhotoBrowser'
    pod 'ProgressHUD'
    
    target 'FlickrSearchTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'FlickrSearchUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['Diff'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
