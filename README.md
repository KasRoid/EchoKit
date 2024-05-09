# EchoKit

![EchoKit Main](https://github.com/KasRoid/EchoKit/blob/develop/Resources/Introducing-EchoKit.jpg)

EchoKit makes it easy to monitor and debug your iOS apps with a straightforward and customizable logging solution.

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
- [Levels](#levels)
- [Getting Started](#getting-started)
    - [Basic Usage](#basic-usage)
    - [Custom Log Levels](#custom-log-levels)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 13.0 or later
- Swift 5.0 or later

## Installation

### Swift Package Manager

To integrate EchoKit into your project using Swift Package Manager, add it as a dependency within your `Package.swift` file:

```swift
dependencies: [
   .package(url: "https://github.com/KasRoid/EchoKit", from: "1.0.0") 
]
```

Alternatively, you can add it via Xcode by navigating to:

`File > Add Packages > Search for 'https://github.com/KasRoid/EchoKit'`

### CocoaPods

Add EchoKit to your `Podfile`:

```text
pod 'EchoKit'
```

Then, run the command:

`pod install`

## Levels

EchoKit offers eight logging levels for monitoring and debugging:

1.**notice**: Typically used for less important messages that may be useful in tracking application flow.

2.**info**: Provides general information about application processes, often used for regular operations.

3.**debug**: Offers detailed debugging information helpful during development to diagnose problems.

4.**trace**: Provides more granular debugging information than `debug`, capturing step-by-step tracing of operations.

5.**warning**: Indicates a possible issue or unexpected situation that isn't necessarily an error but requires attention.

6.**error**: Represents a failure or issue that disrupts normal operation but doesn't cause the program to terminate.

7.**fault**: Signifies a serious failure that can potentially corrupt application state or require a restart to recover.

8.**critical**: Used for extremely severe errors that may cause premature termination and require immediate attention.

## Getting Started

### Basic Usage

1. **Import EchoKit**

Start by importing `EchoKit` wherever you want to use it.

```swift
import EchoKit
```

2. **Start EchoKit**

Initialize EchoKit by calling `Console.start()` once to enable logging. It is recommended to call this in `SceneDelegate` or the `viewDidLoad` method of the first `UIViewController`.

```swift
Console.start()
```

3. **Log Messages**

Use `Console.echo` to log messages at different levels. Note that this will only print messages in the EchoKit console, not the Xcode console.

```swift
Console.echo("Welcome to EchoKit", level: .notice)
```

4. **Integrate with the `print` Function**

You can print messages to the EchoKit console using the `print` function by adopting the `Echoable` protocol.

```swift
final class EchoViewController: UIViewController, Echoable { 

    override func viewDidLoad() { 
        super.viewDidLoad() 
        print("This message appears in both the EchoKit console and Xcode's console.") 
    }
}
```

---

### Custom Log Levels

If you're using custom log levels and would like to integrate them with EchoKit, follow these steps:

1. **Custom Log Levels**

To integrate your custom log levels with EchoKit, adopt the `EchoLevel` protocol.

```swift
enum LogLevel: String, Codable, EchoLevel {
    case network     
    case ga     
    case verbose     
    case info     
    case debug     
    case warning     
    case error     
    case assert     
    case fatal      
    
    public var filterKey: String? {
        rawValue     
    }
    
    public var echoLevel: Level {
        switch self {         
        case .network:
            return .trace         
        case .ga:
            return .info         
        case .verbose:
            return .debug         
        case .info:
            return .info         
        case .debug:
            return .debug         
        case .warning:
            return .warning         
        case .error:
            return .error         
        case .assert:
            return .critical         
        case .fatal:
            return .critical         
    }     
}
```
 
2. **Custom Logger**
    
Implement a custom logger to route messages through EchoKit. For example, if you are using a logger like the one below:

```swift
final class Logger {     
    
    static func log(level: LogLevel, message: Any) {         
        guard let message = message as? String else { return }
        Console.echo(message, level: level)     
    } 
}
```
    
3. **Register Custom Log Levels**

Register your custom log levels with EchoKit.

```swift
Console.register(LogLevel.self)
```

## Credits

- **Doyoung Song**

## License

EchoKit is released under the MIT license. See the LICENSE file for more details.
