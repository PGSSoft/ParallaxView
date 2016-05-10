Pod::Spec.new do |s|

    s.platform = :tvos
    s.tvos.deployment_target = "9.0"
    s.name = "ParallaxView"
    s.summary = "Add parallax effect like in tvOS applications to any view."
    s.requires_arc = true
    s.version = "0.3"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "[Łukasz Śliwiński]" => "[lsliwinski@pgs-soft.com]" }
    s.homepage = "https://bitbucket.org/plum/parallaxview"
    s.source = { :git => "https://bitbucket.org/plum/parallaxview.git", :tag => "0.3" }
    s.framework = "UIKit"
    s.source_files = "Sources/**/*.{swift}"
    s.resources = "Resources/**/*.xcassets"

end
