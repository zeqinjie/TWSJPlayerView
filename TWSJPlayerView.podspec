#
# Be sure to run `pod lib lint TWSJPlayerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TWSJPlayerView'
  s.version          = '0.1.0'
  s.summary          = 'TWSJPlayerView m3u8 视频播放器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
基于 SJVideoPlayer & M3U8Kit  封装 m3u8 视频播放
                       DESC

  s.homepage         = 'https://github.com/zhengzeqin/TWSJPlayerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhengzeqin' => 'zhengzeqin@addcn.com' }
  s.source           = { :git => 'https://github.com/zhengzeqin/TWSJPlayerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TWSJPlayerView/Classes/**/*'
  s.swift_version= "5.0"
#   s.resource_bundles = {
#     'TWSJPlayerView' => ['TWSJPlayerView/Assets/*.png']
#   }
   
  s.resources = "TWSJPlayerView/**/TWSJPlayer.xcassets"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SJVideoPlayer'
   s.dependency 'M3U8Kit'
   s.dependency 'SnapKit'
end
