require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'RNWebim'
  s.version        = package['version']
  s.summary      = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.source       = { :git => "https://github.com/volga-volga/react-native-webim.git", :tag => "v#{s.version}" }

  s.homepage     = package['repository']['url']

  s.requires_arc   = true
  s.platform       = :ios, '9.0'

  s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'
  s.source_files = "ios/*.{h,m,swift}"

  s.dependency 'React'
  s.dependency 'WebimClientLibrary'

end
