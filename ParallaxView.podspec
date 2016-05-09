Pod::Spec.new do |s|

    s.platform = :tvos
    s.tvos.deployment_target = "9.0"
    s.name = "ParallaxView"
    s.summary = "Add parallax effect like in tvOS applications to any view."
    s.requires_arc = true
    s.version = "0.1"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "[Łukasz Śliwiński]" => "[lsliwinski@pgs-soft.com]" }
    s.homepage = "http://EXAMPLE/ParallaxView"
    s.source = { :git => "http://EXAMPLE/ParallaxView.git", :tag => "0.1" }
    s.framework = "UIKit"
    s.source_files = "Sources/**/*.{swift}"
    s.resources = "Resources/**/*.xcassets"

end
