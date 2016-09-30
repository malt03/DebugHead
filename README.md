# DebugHead

[![Platform](https://img.shields.io/cocoapods/p/DebugHead.svg?style=flat)](http://cocoapods.org/pods/DebugHead)
![Language](https://img.shields.io/badge/language-Swift%203.0-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/DebugHead.svg?style=flat)](http://cocoapods.org/pods/DebugHead)
![License](https://img.shields.io/github/license/malt03/DebugHead.svg?style=flat)

![Screenshot](https://raw.githubusercontent.com/malt03/DebugHead/master/Screenshot.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Initialize
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  DebugHead.sharedInstance.prepare(menuClasses: [DebugMenuExit.self, DebugMenuHideDebugHead.self/*, and your plugins */])
}
```

### To Create Plugins
```swift
public class DebugMenuFoo: DebugMenu {
  public static let debugMenuTitle = "Title"
  public static let debugMenuDangerLevel = DebugMenuDangerLevel.[None or Low or High or Extreme]
  public static let debugMenuAccessoryType = UITableViewCellAccessoryType.None
  public static func debugMenuSelected(debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    // Do something
    return nil // If return a UIViewController instance, it will show.
  }
}

```

## Built-in Plugins
- DebugMenuHideDebugHead
- DebugMenuExit

## Recommended Plugins
- [DebugMenuUserDefaultsBrowser](https://cocoapods.org/pods/DebugMenuUserDefaultsBrowser)
- [DebugMenuGPUImageDumper](https://cocoapods.org/pods/DebugMenuGPUImageDumper)

## Installation

DebugHead is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DebugHead"
```

## Author

- Tomoya Hirano, cromteria@gmail.com
- Koji Murata, malt.koji@gmail.com

## License

DebugHead is available under the MIT license. See the LICENSE file for more info.
