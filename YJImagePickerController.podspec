#
# Be sure to run `pod lib lint YJImagePickerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YJImagePickerController'
  s.version          = '1.0.1'
  s.summary          = 'iOS8以上一个简单图片选择封装,支持拍照和相册选择'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.frameworks = 'Photos','AVFoundation'


  s.description      = '简单易用'
  s.homepage         = 'https://github.com/full-of-fire/YJImagePickerController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'full-of-fire' => '591730822@qq.com' }
  s.source           = { :git => 'https://github.com/full-of-fire/YJImagePickerController.git', :tag => s.version.to_s }
  s.default_subspec = 'Core'
  s.subspec 'Core' do |core|
    core.source_files = 'YJImagePickerController/Classes/**/*.{h,m}'
    core.resource_bundles = {
      'YJImagePickerController' => ['YJImagePickerController/Classes/**/*.{xib}','YJImagePickerController/Assets/**/*.png']

    }
  end

  
  # s.resource_bundles = {
  #   'YJImagePickerController' => ['YJImagePickerController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
