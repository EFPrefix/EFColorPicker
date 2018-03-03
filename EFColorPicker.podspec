Pod::Spec.new do |s|
  s.name             = 'EFColorPicker'
  s.version          = '1.1.0'
  s.summary          = 'A lightweight color picker in Swift.'

  s.description      = <<-DESC
EFColorPicker is a lightweight color picker in Swift, inspired by MSColorPicker.
                       DESC

  s.homepage         = 'https://github.com/EyreFree/EFColorPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
  s.source           = { :git => 'https://github.com/EyreFree/EFColorPicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EyreFree777'

  s.ios.deployment_target = '8.0'

  s.requires_arc = true

  s.source_files = 'EFColorPicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'EFColorPicker' => ['EFColorPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
