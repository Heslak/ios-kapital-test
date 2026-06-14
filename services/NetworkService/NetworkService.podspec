require_relative '../../ruby/config.rb'

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name                  = "NetworkService"
  spec.version               = "0.0.1"
  spec.summary               = "A short description of NetworkService."
  spec.homepage              = 'http://github/Heslak/KapitalTest'
  spec.license               = "MIT"
  spec.author                = { "Sergio Acosta" => "ser_acosta_95@hotmail.com" }
  spec.source                = { :git => "http://github/Heslak/KapitalTest.git", :tag => "#{spec.version}" }
  spec.source_files          = 'Sources/**/*.swift'
  spec.swift_version         = $CURRENT_SWIFT_VERSION
  spec.ios.deployment_target = $CURRENT_IOS_VERSION
  
  spec.resource_bundles = {
    'NetworkServiceResources' => [
      "Sources/**/*.lproj/*.{strings,stringsdict}",
      "Sources/**/*.{json}",
      "Sources/**/*.xcassets"
    ]
  }

  spec.test_spec "#{spec.name}Tests" do |ss|
    ss.source_files = 'Tests/**/*.swift'
    ss.ios.resources = ['Tests/**/*.{json}']
  end
end
