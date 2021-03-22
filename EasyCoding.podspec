#
# Be sure to run `pod lib lint EasyCoding.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyCoding'
  s.version          = '0.1.2'
  s.summary          = '提供日常开发最常用的操作封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fanxiaoxin/EasyCoding'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanxiaoxin  ' => 'fanxiaoxin_1987@126.com' }
  s.source           = { :git => 'https://github.com/fanxiaoxin/EasyCoding.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

#  s.source_files = 'EasyCoding/Classes/**/*'
  
  s.swift_version = '5.3'
  
#  s.resource_bundles = {
#      'EasyCoding' => ['EasyCoding/Assets/*.xcassets']
#  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#  s.dependency 'SnapKit', '~> 5.0'
  
  s.default_subspecs = 'Basic'
  # 最基本的操作
  s.subspec 'Basic' do |sub|
      sub.dependency 'SnapKit', '~> 5.0'
      sub.source_files = 'EasyCoding/Classes/Basic/**/*'
  end
  # 事件
  s.subspec 'Event' do |sub|
    sub.dependency 'EasyCoding/Basic'
    sub.source_files = 'EasyCoding/Classes/Event/**/*'
    sub.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => ['-D','EASY_EVENT'] }
  end
  # 视图呈现
  s.subspec 'Present' do |sub|
    sub.dependency 'EasyCoding/Basic'
    sub.source_files = 'EasyCoding/Classes/Present/**/*'
  end
  # 数据处理
  s.subspec 'Data' do |sub|
#    sub.dependency 'MJRefresh', '~> 3.4.0'
    sub.dependency 'EasyCoding/Basic'
    sub.source_files = 'EasyCoding/Classes/Data/**/*'
    sub.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => ['-D','EASY_DATA'] }
  end
  # 控制器加载方案
  s.subspec 'ViewControllerLoad' do |sub|
    sub.dependency 'EasyCoding/Present'
    sub.source_files = 'EasyCoding/Classes/ViewControllerLoad/**/*'
    sub.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => ['-D','EASY_VIEWCONTROLLERLOAD'] }
  end
  # 控件
  s.subspec 'Controls' do |sub|
    sub.dependency 'EasyCoding/Event'
    sub.dependency 'EasyCoding/ViewControllerLoad'
    sub.dependency 'YYKeyboardManager', '~> 1.0.0'
    sub.resource_bundles = {
      'EasyCoding' => ['EasyCoding/Assets/Controls.xcassets']
    }
#    sub.dependency 'Kingfisher', '~> 5.14.0'
#    sub.dependency 'MJRefresh', '~> 3.4.0'
    sub.source_files = 'EasyCoding/Classes/Controls/**/*'
    sub.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => ['-D','EASY_CONTROLS'] }
  end
  # Api封装
  s.subspec 'Api' do |sub|
    sub.dependency 'EasyCoding/Data'
    sub.dependency 'Moya', '~> 13.0'
    sub.dependency 'HandyJSON', '~> 5.0.0'
    sub.source_files = 'EasyCoding/Classes/Api/**/*'
  end
  # 个性化方案
  s.subspec 'Personalized' do |sub|
    sub.dependency 'EasyCoding/Basic'
    sub.source_files = 'EasyCoding/Classes/Personalized/**/*'
  end
  # 主题方案
  s.subspec 'ThemeManager' do |sub|
    sub.source_files = 'EasyCoding/Classes/ThemeManager/**/*'
  end
  # Kingfisher扩展
  s.subspec 'Kingfisher' do |sub|
    sub.dependency 'Kingfisher', '~> 6.0'
  end
  # MJRefresh扩展
  s.subspec 'MJRefresh' do |sub|
    sub.dependency 'MJRefresh', '~> 3.4'
  end
  # Promise扩展
  s.subspec 'Promise' do |sub|
    sub.dependency 'PromiseKit', '~> 6.13'
  end
  
  # 常用的组件
  s.subspec 'Common' do |sub|
      sub.dependency 'EasyCoding/Controls'
      sub.dependency 'EasyCoding/Api'
      sub.dependency 'EasyCoding/Kingfisher'
      sub.dependency 'EasyCoding/MJRefresh'
  end
end
