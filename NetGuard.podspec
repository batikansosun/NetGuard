Pod::Spec.new do |s|
  s.name         = "NetGuard"
  s.version      = "1.7"
  s.summary      = "Network debugging guard"
  s.description  = <<-DESC
    A lightweight network debugger. Start network debugging with NetGuard you never miss any request.
  DESC
  s.homepage     = "https://github.com/batikansosun/NetGuard"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Batikan Sosun" => "batikansosun@gmail.com" }
  s.social_media_url   = "https://twitter.com/batikansosun"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/batikansosun/NetGuard.git", :branch => "main", :tag => "#{s.version}" }
  s.source_files     = "NetGuard", "NetGuard/**/*.{h,m,swift}"
  #s.resources = "NetGuard", "NetGuard/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  s.swift_version = "5.0"
end
