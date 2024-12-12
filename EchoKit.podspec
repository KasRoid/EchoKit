Pod::Spec.new do |s|
  s.name         = "EchoKit"
  s.version      = "1.1.1"
  s.summary      = "A simple and customizable logging solution for iOS apps."

  s.description  = <<-DESC
                   EchoKit makes it easy to monitor and debug your iOS apps with a straightforward and customizable logging solution.
                   DESC

  s.homepage     = "https://github.com/KasRoid/EchoKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Doyoung Song" => "KasRoid@gmail.com" }
  s.source       = { :git => "https://github.com/KasRoid/EchoKit.git", :tag => s.version.to_s }
  
  s.ios.deployment_target = "13.0"
  s.swift_version = "5.0"

  s.source_files  = "Sources/EchoKit/**/*.{swift,xib}"
  s.exclude_files = "Tests"
end
