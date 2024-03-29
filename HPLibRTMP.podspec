#
# Be sure to run `pod lib lint HPLibRTMP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HPLibRTMP'
  s.version          = '0.0.3'
  s.summary          = 'librtmp objective-c warper.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/huiping192/HPLibRTMP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huiping_guo' => 'huiping192@gmail.com' }
  s.source           = { :git => 'https://github.com/huiping192/HPLibRTMP.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/huiping192'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HPLibRTMP/Classes/**/*'
  s.public_header_files = 'HPLibRTMP/Classes/**/*.h'
  
  s.dependency 'pili-librtmp'
end
