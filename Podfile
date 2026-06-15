# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

def services
  pod 'LocalStorageService', :path => 'services/LocalStorageService', :testspecs => ['LocalStorageServiceTests']
  pod 'NetworkService', :path => 'services/NetworkService', :testspecs => ['NetworkServiceTests']
end

def ui
  pod 'DesignSystem', :path => 'ui/DesignSystem'
end

target 'KapitalTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KapitalTest

  services
  ui
  
  target 'KapitalTestTests' do
    inherit! :search_paths
  end

  target 'KapitalTestUITests' do
  end

end


