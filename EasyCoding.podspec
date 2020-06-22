#
# Be sure to run `pod lib lint EasyCoding.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyCoding'
  s.version          = '0.0.2'
  s.summary          = '提供日常开发常用的操作及控件的封装'

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

  s.source_files = 'EasyCoding/Classes/**/*'
  
  s.swift_version = '5.2'
  
  # s.resource_bundles = {
  #   'EasyCoding' => ['EasyCoding/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # 最基本的操作
  s.subspec 'Basic' do |b|
      b.source_files = 'EasyCoding/Classes/1.Basic/**/*'
      b.dependency 'SnapKit', '~> 5.0.0'
  end
  # 定制化的操作，比如多语言或多主题
  s.subspec 'Personalized' do |p|
      p.source_files = 'EasyCoding/Classes/2.Business/2.1.Personalized/**/*'
      p.dependency 'EasyCoding/Basic'
  end
  # ViewController的访问控制，提供统一的加载方法，可定制加载的先决条件及跳转方式、多页面加载流程
  s.subspec 'AccessControl' do |p|
      p.source_files = 'EasyCoding/Classes/2.Business/2.2.AccessControl/**/*'
      p.dependency 'EasyCoding/Basic'
  end
  # 将每一个API请求的相关字段都封装为一个对象，可以清晰地看到每一个API的请求地址、方式、请求结构、响应结构等操作
  s.subspec 'Api' do |a|
      a.source_files = 'EasyCoding/Classes/2.Business/2.3.Api/**/*'
      a.dependency 'EasyCoding/Basic'
      a.dependency 'Moya', '~> 13.0.0'
      a.dependency 'HandyJSON', '~> 5.0.0'
  end
  # 提供一些控件及界面相关的工具
  s.subspec 'Controls' do |c|
    c.source_files = 'EasyCoding/Classes/3.Controls/**/*','EasyCoding/Classes/4.plugs/{T,V}*/**/*'
    c.dependency 'EasyCoding/AccessControl'
    c.dependency 'JRSwizzle'
    c.dependency 'YYKeyboardManager', '~> 1.0.0'
    c.dependency 'Kingfisher', '~> 5.14.0'
   end
   # 提供列表及API绑定数据的封装，新建一个TableView不需要写太多重复的代码，包含上下拉刷新
   s.subspec 'ListLoader' do |l|
       l.source_files = 'EasyCoding/Classes/4.plugs/ApiListLoader/**/*'
       l.dependency 'EasyCoding/Api'
       l.dependency 'MJRefresh', '~> 3.4.0'
   end
end
