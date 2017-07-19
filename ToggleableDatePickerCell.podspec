Pod::Spec.new do |s|
    s.name         = 'ToggleableDatePickerCell'
    s.version      = '1.0.0'
    s.license      = { :type => 'MIT' }
    s.homepage     = 'https://github.com/stanft/DatePickerCell'
    s.authors      = {'Dylan Vann' => 'dylanvann@gmail.com',
                      'Stephan Anft' => 'trivial@gmx.net'}
    s.summary      = 'Activatable inline/expanding date picker for table views.'
    s.screenshot  = "http://i.imgur.com/dpHIzw8.gif"
    s.ios.deployment_target = '9.0'
    s.source       = { :git => 'https://github.com/stanft/DatePickerCell.git', :branch => 'activatable' }
    s.source_files = 'Source/*.{swift,xib}'
end
