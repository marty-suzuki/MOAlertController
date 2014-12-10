#
# Be sure to run `pod lib lint MOAlertController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MOAlertController"
  s.version          = "0.1.0"
  s.summary          = "MOAlertController is wapper class to assign UIAlertController, UIAlertView and UIActionSheet."

  s.homepage         = "https://github.com/szk-atmosphere/MOAlertController"
  s.license          = 'MIT'
  s.author           = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.source           = { :git => "https://github.com/szk-atmosphere/MOAlertController.git", :tag => "v0.1.0" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'MOAlertController/*.{h,m}'
end