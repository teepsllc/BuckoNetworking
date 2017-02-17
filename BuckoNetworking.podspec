Pod::Spec.new do |spec|
  spec.name = "BuckoNetworking"
  spec.version = "1.0.1"
  spec.summary = "Protocol Oriented Networking"
  spec.homepage = "https://github.com/teepsllc/BuckoNetworking"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Teeps LLC" => 'info@teeps.org' }
  spec.social_media_url = "http://twitter.com/teepsmobile"

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/teepsllc/BuckoNetworking.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "BuckoNetworking/**/*.{h,swift}"

  spec.dependency "Alamofire", "~> 4.3"
  spec.dependency "SwiftyJSON", "~> 3.1"
end
