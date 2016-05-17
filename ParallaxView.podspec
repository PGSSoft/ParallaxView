Pod::Spec.new do |s|

    s.platform = :tvos
    s.tvos.deployment_target = "9.0"
    s.name = "ParallaxView"
    s.summary = "Add parallax effect like in tvOS applications to any view."
    s.requires_arc = true
    s.version = "1.0.7"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "[Łukasz Śliwiński]" => "[lsliwinski@pgs-soft.com]" }
    s.homepage = "https://bitbucket.pgs-soft.com/scm/mosp/pgs-parallaxview.git"
    s.source = { :git => "https://bitbucket.pgs-soft.com/scm/mosp/pgs-parallaxview.git", :branch => "master", :tag => s.version }
    s.framework = "UIKit"
    s.source_files = "Sources/**/*.{swift}"
    s.resources = "Resources/**/*.xcassets"

end
