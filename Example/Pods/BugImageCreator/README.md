# BugImageCreator

[![Platform](https://img.shields.io/cocoapods/p/BugImageCreator.svg?style=flat)](http://cocoapods.org/pods/BugImageCreator)
![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/BugImageCreator.svg?style=flat)](http://cocoapods.org/pods/BugImageCreator)
![License](https://img.shields.io/github/license/malt03/BugImageCreator.svg?style=flat)

![Screenshot](https://raw.githubusercontent.com/malt03/BugImageCreator/master/Screenshot.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### via code

```swift
let image = BugImageCreator.getCacheOrCreate(size: 50, lineWidth: 1, color: .blackColor())
```

or

```swift
public override func drawRect(rect: CGRect) {
  super.drawRect(rect)
  BugImageCreator.drawToCurrentContext(size: rect.size, center: CGPoint(x: rect.width / 2, y: rect.height / 2), lineWidth: 1, color: .blackColor())
}
```

### via Interface Builder
![ib](https://github.com/malt03/BugImageCreator/blob/master/README/InterfaceBuilder.png?raw=true)

## Installation

BugImageCreator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BugImageCreator"
```

## Author

Koji Murata, malt.koji@gmail.com

## License

BugImageCreator is available under the MIT license. See the LICENSE file for more info.
