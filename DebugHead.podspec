#
# Be sure to run `pod lib lint DebugHead.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DebugHead'
  s.version          = '3.0.0'
  s.summary          = 'DebugHead like Facebook chat head.'

  s.description      = <<-DESC
DebugHead is a pod for debug.
It can present a view like Facebook chat head.
When you tap it, it will open a debug menu.
And, you can make plugin easy.
                       DESC

  s.homepage         = 'https://github.com/malt03/DebugHead'
  s.screenshots      = 'https://raw.githubusercontent.com/malt03/DebugHead/master/Screenshot.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = {
    'Tomoya Hirano' => 'cromteria@gmail.com',
    'Koji Murata' => 'malt.koji@gmail.com',
  }
  s.source           = { :git => 'https://github.com/malt03/DebugHead.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'DebugHead/Classes/**/*'

  s.resource_bundles = {
    'DebugHead' => ['DebugHead/Assets/*']
  }

  s.dependency 'BugImageCreator', '~> 1.0.0'
end
