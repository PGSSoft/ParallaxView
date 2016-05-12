<p align="center">
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat" alt="Swift" /></a>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Platforms-tvOS-lightgray.svg?style=flat" alt="Platform" /></a>
    <a href="https://tldrlegal.com/license/mit-license"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat" alt="License" /></a>
</p>

# ParallaxView

UIView and UICollectionViewCell with parallax effect. Rotate view using Apple TV remote.
Works confusingly similar to tiles in home screen of Apple TV.
Written in Swift 😍

![](Assets/parallax_view.gif)
![](Assets/parallax_collection_view_cell.gif)

## Usage

To start using the component add it to your project using CocoaPods, Carthage or manually as per the Installation section.

### ParallaxView

To create parallax view intance put `UIView` using *Interface builder* and change its class to `ParallaxView` in *Identity inspector* or do it from code.

### ParallaxCollectionViewCell

In *Interface builder* change collection view cell class to `ParallaxCollectionViewCell` or do it from code.

You can also create subclass of `ParallaxCollectionViewCell` insted of `UICollectionViewCell` and usit is as normal collection view cell.

## Customization

The component is documented in code, also look into example for more details.

### Properties

`ParallaxView` and `ParallaxCollectionViewCell` have the same properties for customization.

* `parallaxEffect` - configure parallax effect (pan, angles, etc.)
* `subviewsParallaxType` - enum that allow you to configure parallax effect for subviews of the `ParallaxView`
* `shadowPanDeviation` - maximal value of points that shadow of the `ParallaxView` will be moved during parallax effect
* `glowEffectAlpha` - configure alpha of the glow effect
* `glowEffectContainerView` - view that will be used as the container for glow effect. You don't have to configure this becouse for `ParallaxView` will be automatically created subview for this purpose, while for `ParallaxCollectionViewCell` will be used `contentView` of the cell. But if you want to, you can define custom view - look into example project for more details.
* cornerRadius - use this value insted of `self.view.layer.cornerRadius`. This will automatically correct radius for glow effect view if it is necessary

### Subclassing

You can also customize `ParallaxView` and `ParallaxCollectionViewCell` creating a subclass and overriding especially the following methods:

* `setupUnfocusedState()` - method will be called inside `CoordinatedAnimations` block of transition to unfocused state. Use this to figure animatable properties e.g. transform.
* `setupFocusedState()` - as well as `setupUnfocusedState` but in transition to focused state.
* `beforeBecomeFocusedAnimation()` - override this method if you want to make some adjustments before animation to the focused state start.
* `beforeResignFocusAnimation()` - as well as `beforeBecomeFocusedAnimation` but before unfocus state.

## Requirements

Swift 2.2, tvOS 9.0

## Installation

#### CocoaPods

The control is available through [CocoaPods](https://cocoapods.org/). CocoaPods can be installed using [Ruby gems](https://rubygems.org/):
```shell
$ gem install cocoapods
```

Then simply add `ParallaxView` to your Podfile:

```
pod 'ParallaxView', '~> 1.0'
```

Lastly, let CocoaPods fetch the latest version of the component by running:
```shell
$ cocoapods update
```

#### Carthage
The component supports [Carthage](https://github.com/Carthage/Carthage). Start by making sure you have the latest version of Carthage installed. Using [Homebrew](http://brew.sh/) run this:
```shell
$ brew update
$ brew install carthage
```
Then add `ParallaxView` to your `Cartfile`:
```
github "pgs-software/ParallaxView"
```
Finally, add the framework to the Xcode project of your App. Link the framework to your App and copy it to the App’s Frameworks directory via the “Build Phases” section.

#### Manual

You can download the latest files from our [Releases page](https://github.com/pgs-software/ParallaxView/releases). After doing so, drag `ParallaxView.xcodeproj` into your project in Xcode, and for your project target on ***General*** tab in ***Embedded Binaries*** section add `ParallaxView.framework`. Example project is configured the same way, so you have a crib sheet.

## Author

Łukasz Śliwiński

Twitter: [sliwinskilukas](https://twitter.com/sliwinskilukas)

## License

**ParallaxView** is under MIT license. See [LICENSE](LICENSE) for details.

