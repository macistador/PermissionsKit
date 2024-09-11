# PermissionsKit
Native permissions framework facilitating collecting users access approval to Camera, Photo Library, Microphone, Contacts, Location, Notifications and Tracking.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Get permissions status and be notified by changes
- [x] Ask for permissions with built-in prompts 

## Requirements

- iOS 15.0+
- Xcode 12.0+
- Swift 5.5+

## Installation

### SwiftPackageManager

```swift
dependencies: [
    .package(url: "https://github.com/macistador/PermissionsKit", from: "0.0.1")
]
```

## Usage

### Preview

With __SwiftUI__
```swift
        

```

With __UIKit__
```swift
    

```

### Callbacks

Your object needs to conforms __xxxxDelegate__
```swift
extension DemoView: xxxxDelegate {
    
}
```

For more details you may take a look at the sample project.

## Credits

PermissionsKit is developed and maintained by Michel-André Chirita. You can follow me on Twitter at @Macistador for updates.

## License

PermissionsKit is released under the MIT license. [See LICENSE](https://github.com/macistador/permissionskit/blob/master/LICENSE) for details.
