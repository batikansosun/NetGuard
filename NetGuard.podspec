Pod::Spec.new do |s|
  s.name         = "NetGuard"
  s.version      = "1.0"
  s.summary      = "Network debugging guard"
  s.description  = <<-DESC
    An excellent network debugger. Start network debugging with NetGuard you never miss any request.
  DESC
  s.homepage     = "https://github.com/batikansosun/NetGuard"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Batikan Sosun" => "batikansosun@gmail.com" }
  s.social_media_url   = "https://twitter.com/batikansosun"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/batikansosun/NetGuard.git", :tag => s.version.to_s }
  s.source_files     = "NetGuard", "NetGuard/**/*.{h,m,swift}"
  s.swift_version = "5.0"
end
