# NetGuard

[![Pod version](https://img.shields.io/badge/pod-v1.0-green)](https://cocoapods.org/pods/NetGuard)
[![Swift Version](https://img.shields.io/badge/Swift-v5-red)](https://cocoapods.org/pods/NetGuard)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-lightgrey)](https://github.com/batikansosun/NetGuard/LICENSE)
[![LICENSE](https://img.shields.io/badge/Platform-iOS-yellowgreen)](https://github.com/batikansosun/NetGuard/LICENSE)
[![TWITTER](https://img.shields.io/badge/Twitter%20Support-%40batikansosun-yellow)](https://github.com/batikansosun/NetGuard/LICENSE)
[![Pod version](https://img.shields.io/badge/Cocoapods-compatible-green)](https://cocoapods.org/pods/NetGuard)




## Preview
![NetGuard](https://github.com/batikansosun/NetGuard/blob/main/NetGuardDemo/SS/NetGuard-SS3.png?raw=true)
![NetGuard](https://github.com/batikansosun/NetGuard/blob/main/NetGuardDemo/SS/NetGuard-SS2.png?raw=true)
![NetGuard](https://github.com/batikansosun/NetGuard/blob/main/NetGuardDemo/SS/NetGuard-SS1.png?raw=true)


## Introduction

- NetGuard is a lightweight native iOS network debugger. 
- NetGuard monitors and capture network requests. 
- NetGuard stores and lists what it has captured in readable, detailed and secure form. 
- NetGuard makes debugging fast and reliable.
- Just shake iPhone and NetGuard will show.

## Requirements

- iOS 10.0+
- Xcode 10+
- Swift 4, 4.1, 4.2 and Swift 5


## Installation

### CocoaPods
```ruby
target 'YourTargetName' do
    use_frameworks!
    pod 'NetGuard'
end
```

## Usage
All you need is to call the "loadNetGuard" method in "didFinishLaunchingWithOptions" "AppDelegate". That's it
```swift
//import NetGuard
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      NetGuard().loadNetGuard()
      return true
  }
```
### Parameters
'enabled' default value is true. You don't need to setting up to 'true'. 'false' value disables network watching.
```swift
NetGuard.enabled = false
```
'shakeEnabled' default value is true. You don't need to setting up to 'true' for shake for showing request list UI.
```swift
NetGuard.shakeEnabled = false
```
You can disable shake with setting up to 'false' and you can call 'showNetGuard()' anywhere.
```swift
NetGuard().showNetGuard()
```
With 'blackListHosts' you can exclude requests you defined.
```swift
NetGuard.blackListHosts = ["example.com"]
```
## Contributing
- If you **found a bug**, please open an issue.
- If you **have a feature request**, please open an issue.
- If you **want to contribute**, please submit a pull request.

**Made with ❤️ by [Batikan Sosun](https://github.com/batikansosun)**
#### For more follow me on the Twitter [Batikan Sosun](https://twitter.com/batikansosun)


## MIT License
NetGuard is available under the MIT license. See the <a href="https://github.com/batikansosun/NetGuard/blob/main/LICENSE">LICENSE file</a> for more info.


