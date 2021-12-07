#
# Be sure to run `pod lib lint JKSwiftLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKSwiftLibrary'
  s.version          = '1.0.0'
  s.summary          = '工具库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
#TODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://github.com/albert/JKSwiftLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'albert' => 'jkdev123cool@gmail.com' }
  s.source           = { :git => 'https://github.com/albert/JKSwiftLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  #s.source_files = 'JKSwiftLibrary/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JKSwiftLibrary' => ['JKSwiftLibrary/Assets/*.png']
  # }
  
  s.resource = 'JKSwiftLibrary/Assets/JKSwiftLibraryResource.bundle'
  
  s.default_subspec = ['Core']
  
  s.subspec 'Core' do |ss|
      ss.source_files = 'JKSwiftLibrary/Classes/Core/**/*'
      
      ss.framework  = "UIKit", "Foundation"
  end
  
  s.subspec 'Extension' do |ss|
      ss.dependency 'JKSwiftLibrary/Core'
      ss.source_files = 'JKSwiftLibrary/Classes/Extension/**/*'
  end
  
  s.subspec 'BaseClass' do |ss|
      ss.dependency 'JKSwiftLibrary/Core'
      ss.source_files = 'JKSwiftLibrary/Classes/BaseClass/**/*'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.swift_version = '5.0'
end
