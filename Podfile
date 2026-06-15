# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

def services
  pod 'LocalStorageService', :path => 'services/LocalStorageService', :testspecs => ['LocalStorageServiceTests']
  pod 'NetworkService', :path => 'services/NetworkService', :testspecs => ['NetworkServiceTests']
end

def ui
  pod 'DesignSystem', :path => 'ui/DesignSystem'
end

def quality
  pod 'SwiftLint'
end

target 'KapitalTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KapitalTest

  services
  ui
  quality
  
  target 'KapitalTestTests' do
    inherit! :search_paths
  end

  target 'KapitalTestUITests' do
  end

end

# SwiftLint Build Phase Script
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end


