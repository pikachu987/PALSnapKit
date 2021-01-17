#
# Be sure to run `pod lib lint PALSnapKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PALSnapKit'
  s.version          = '0.1.0'
  s.summary          = 'PALSnapKit'
  s.description      = <<-DESC
My Lib PALSnapKit
                       DESC
  s.homepage         = 'https://github.com/pikachu987/PALSnapKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PALSnapKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'PALSnapKit/Classes/**/*'
  s.swift_version = '5.0'
  s.dependency 'SnapKit', '5.0.1'
end
