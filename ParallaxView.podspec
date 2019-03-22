Pod::Spec.new do |s|

    s.platform = :tvos
    s.tvos.deployment_target = "9.0"
    s.name = "ParallaxView"
    s.summary = "Add parallax effect like in tvOS applications to any view."
    s.requires_arc = true
    s.license = "MIT"
    s.version = "2.0.9"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "[Vince Liang]" => "[vince.yu.liang@gmail.com]" }
    s.homepage = "https://github.com/zaully/ParallaxView"
    s.source = { :git => "https://github.com/zaully/ParallaxView.git", :tag => s.version }
    s.framework = "UIKit"
    s.source_files = "Sources/**/*.{swift}"
    s.resources = "Resources/**/*.xcassets"

end
