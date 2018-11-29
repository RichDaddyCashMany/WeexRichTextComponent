#
# Be sure to run `pod lib lint KSWXRichTextComponent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSWXRichTextComponent'
  s.version          = '0.0.1'
  s.summary          = 'this is a weex rich text component'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'this is a weex rich text component named KSWXRichTextComponent'

  s.homepage         = 'https://github.com/HJaycee/WeexRichTextComponent.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HJaycee' => 'hjaycee@163.com' }
  s.source           = { :git => 'https://github.com/HJaycee/WeexRichTextComponent.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.ios.source_files = 'Lib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KSWXRichTextComponent' => ['KSWXRichTextComponent/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreText'
  s.dependency "WeexSDK"
end
