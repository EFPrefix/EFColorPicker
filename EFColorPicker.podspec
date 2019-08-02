Pod::Spec.new do |s|
    s.name             = 'EFColorPicker'
    s.version          = '5.1.0'
    s.summary          = 'A lightweight color picker in Swift.'
    
    s.description      = <<-DESC
    EFColorPicker is a lightweight color picker in Swift, inspired by MSColorPicker.
    DESC

    s.homepage         = 'https://github.com/EFPrefix/EFColorPicker'
    s.screenshots      = 'https://raw.githubusercontent.com/EFPrefix/EFColorPicker/master/Assets/EFColorPicker.png'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
    s.source           = { :git => 'https://github.com/EFPrefix/EFColorPicker.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/EyreFree777'

    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.source_files = 'EFColorPicker/Classes/**/*'
end
