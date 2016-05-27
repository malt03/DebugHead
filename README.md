# DebugHead

[![Platform](https://img.shields.io/cocoapods/p/DebugHead.svg?style=flat)](http://cocoapods.org/pods/DebugHead)
![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/DebugHead.svg?style=flat)](http://cocoapods.org/pods/DebugHead)
![License](https://img.shields.io/github/license/malt03/DebugHead.svg?style=flat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Initialize
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  DebugHead.sharedInstance.prepare(menuClasses: [DebugMenuExit.self, DebugMenuHideDebugHead.self])
}
```

### Creating Plugins
```swift
public class DebugMenuExit: DebugMenu {
  public static let debugMenuTitle = "Title"
  public static let debugMenuDangerLevel = DebugMenuDangerLevel.[None or Low or High or Extreme]
  public static let debugMenuAccessoryType = UITableViewCellAccessoryType.None
  public static func debugMenuSelected(debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    // Do something
    return nil // If return a UIViewController instance, it will show.
  }
}

```

## Installation

DebugHead is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DebugHead"
```

## Author

Koji Murata, malt.koji@gmail.com

## License

DebugHead is available under the MIT license. See the LICENSE file for more info.
