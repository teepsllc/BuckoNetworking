# iOS Protocol Oriented Networking in Swift

When one of our projects transitioned to another engineer, we noticed that everyone's networking code was different. We didn't like that everytime someone took over a project, they had to "learn" that network layer. To solve this, the iOS Engineers decided that we should all use the same networking setup to solve these headaches, thus we looked into Protocol Oriented Networking.


### Dependencies
------

We ended up going with [Alamofire](https://github.com/Alamofire/Alamofire) instead of `URLSession` for a few reasons. Alamofire is asynchronous by nature, has session management, reduces boilerplate code, and is very easy to use.

[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

### Installation
------

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate BuckoNetworking into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "teepsllc/BuckoNetworking"
```

Run `carthage update` to build the framework and drag the built `BuckoNetworking.framework` into your Xcode project.

To use BuckoNetworking, just import the needed modules.

```swift
import BuckoNetworking
import Alamofire
import SwiftyJSON
```

#### CocoaPods

Note: We don't use CocoaPods, so this may or may not work.

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate BuckoNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BuckoNetworking', :git => 'https://github.com/teepsllc/BuckoNetworking.git'
end
```

Then, run the following command:

```bash
$ pod install
```


### Blog
------

You can go to our [Blog](https://staging.teeps.org/blog/2017/02/07/27-protocol-oriented-networking-in-swift) to read more.
