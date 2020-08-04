![PGS Software](https://github.com/PGSSoft/ParallaxView/raw/master/Assets/pgssoft-logo.png) 

# ParallaxView

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ParallaxView.svg)](https://cocoapods.org/pods/ParallaxView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/cocoapods/p/ParallaxView.svg)](http://cocoadocs.org/docsets/ParallaxView)
[![License](https://img.shields.io/cocoapods/l/ParallaxView.svg)](https://github.com/PGSSoft/ParallaxView/LICENSE.md)

## Summary

**Easy to use `UIView`, `UICollectionViewCell` with parallax effect and extensions to add this effect to any `UIView`. Rotate view using Apple TV remote. Works confusingly similar to tiles in the home screen of the Apple TV.**

![ParallaxView](https://github.com/PGSSoft/ParallaxView/raw/master/Assets/parallax_view.gif)
![ParallaxView](https://github.com/PGSSoft/ParallaxView/raw/master/Assets/parallax_collection_view_cell.gif)

### ParallaxView

Open your storyboard or xib and drag and drop `UIView` control.
Change custom class to `ParallaxView` in *Identity inspector*.
You can also create control from code.

### ParallaxCollectionViewCell

In *Interface builder* change collection view cell class to `ParallaxCollectionViewCell` or do it from code.

You can also create subclass of `ParallaxCollectionViewCell` insted of `UICollectionViewCell` and use it as normal collection view cell.

### Extension

If `ParallaxView` and `ParallaxCollectionViewCell` don't fit to your needs you can use extension that can be used with any `UIView`. In many cases it can look like in this example:

```swift
override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
	coordinator.addCoordinatedAnimations({
		if context.nextFocusedView === yourCustomView {
			yourCustomView.addParallaxMotionEffects()
		}
		if context.previouslyFocusedView === yourCustomView {
			yourCustomView.removeParallaxMotionEffects()
		}
	}, completion: nil)
}
```

It is important to add and remove parallax effect inside the animation block to avoid the glitches.
`ParallaxView` and `ParallaxCollectionViewCell` internally use the same methods.
For more details look into example.

## Customisation

The component is documented in code, also look into example for more details.

[Documentation](https://pgssoft.github.io/ParallaxView/)

### Properties

`ParallaxView` and `ParallaxCollectionViewCell` have the same properties for customisation.

* `parallaxEffectOptions` - using this property you can customize parallax effect.
	* `parallaxMotionEffect` - configure parallax effect (pan, angles, etc.)
	* `subviewsParallaxMode` - enum that allow you to configure parallax effect for subviews of the `ParallaxView`
	* `shadowPanDeviation` - maximal value of points that shadow of the `ParallaxView` will be moved during parallax effect
	* `glowAlpha` - configure alpha of the glow effect (if is equal to 0.0 then the glow effect will be not added)
	* `parallaxSubviewsContainer` - custom container view that will be usead to apply subviews parallax effect. By default it will be parallaxable view by itself.
	* `glowContainerView` - view that will be used as the container for the glow effect. You don't have to configure this because for `ParallaxView` it will be automatically created a subview for this purpose, while for `ParallaxCollectionViewCell` it will be used `contentView` of the cell. Also by default it is nil when you use extension (`self` will be used as the glow container but only if `glowAlpha` is bigger than 0.0). But if you want to, you can define custom view - look into example project for more details.
	* `glowImageView` - image view that will be used as the glow effect. `ParallaxView` framework provides default image that will be set.
* `glowPosition` - (`.top` default) - allows to customize position of the glow effect related to the `glowImageContainer`. You can provide custom setup by creating `GlowPosition` instance. 
	
* `parallaxViewActions` - use properties of this property to change default behaviours of the parallax view. Internally both `ParallaxView` and `ParallaxCollectionViewCell` calls callbacks.
	* `setupUnfocusedState ` - closure will be called in animation block when view should change its appearance to the focused state
	* `setupFocusedState` - closure will be called in animation block when view should change its appearance to the unfocused state
	* `beforeBecomeFocusedAnimation` - closure will be called before the animation to the focused change start
	* `beforeResignFocusAnimation` - closure will be called before the animation to the unfocused change start
	* `becomeFocused ` - closure will be called when didFocusChange happened. In most cases default implementation should work
   * `resignFocus ` - closure will be called when didFocusChange happened. In most cases default implementation should work.
	* `animatePressIn` - default implementation of the press begin animation
	* `animatePressOut` - default implementation of the press ended animation
* `cornerRadius` - use this value insted of `self.view.layer.cornerRadius`. This will automatically correct radius for glow effect view if it is necessary

## Requirements

Swift 5.0, tvOS 9.0

## Installation

* #### [CocoaPods](https://cocoapods.org/)

Add line to Podfile 

```ruby
# ...
target 'MyApp' do
  # your other pod
  # ...
  pod 'ParallaxView'
end
# ...
```

* #### [Carthage](https://github.com/Carthage/Carthage)

Add a line to `Cartfile`:

```
github "PGSSoft/ParallaxView"
```

* #### [Swift Package Manager (SPM)](https://swift.org/package-manager/)

**Xcode 12 (Swift 5.3) required!**

In Xcode: 

***Select File > Swift Packages > Add Package Dependency. Enter https://github.com/PGSSoft/ParallaxView***

If you would like to check more details please visit the Apple's [documentation](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

* #### Manual

You can download the latest files from our [Releases page](https://github.com/PGSSoft/ParallaxView/releases). After doing so, drag `ParallaxView.xcodeproj` into your project in Xcode, and for your project target on ***General*** tab in ***Embedded Binaries*** section add `ParallaxView.framework`. Example project is configured the same way, so you have the crib sheet.

## Usage

```swift
import ParallaxView
```


## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/PGSSoft/ParallaxView](https://github.com/PGSSoft/ParallaxView).

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About

The project maintained by [software development agency](https://www.pgs-soft.com/) [PGS Software](https://www.pgs-soft.com/).
See our other [open-source projects](https://github.com/PGSSoft) or [contact us](https://www.pgs-soft.com/contact-us/) to develop your product.

## Follow us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/PGSSoft/InAppPurchaseButton)  
[![Twitter Follow](https://img.shields.io/twitter/follow/pgssoftware.svg?style=social&label=Follow)](https://twitter.com/pgssoftware)