Pod::Spec.new do |s|

  s.name         = "MBMessagesSwiftNotificationService"
  s.version      = "0.2.3"
  s.summary      = "MBurger messages plugin."
  s.swift_version = '4.2'
  s.description  = "MBurger messages plugin used to show in app messages using MBurger iOS SDK."

  s.homepage = "https://github.com/Mumble-SRL/MBMessagesSwift"

  s.license = { :type => "Apache", :file => "LICENSE" }

  s.author = { "LorenzOliveto" => "lorenzo.oliveto@mumbleideas.it" }

  s.platform     = :ios
  s.ios.deployment_target = "11.0"

  s.source       = { git: 'https://github.com/Mumble-SRL/MBMessagesSwift.git', tag: '0.2.3' }
  s.source_files = [
    "MBMessagesSwift/Notification Service/*.{h,m,swift}"
  ]

  s.frameworks = "UserNotifications"
  s.requires_arc = true
end
