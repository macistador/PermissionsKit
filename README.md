# PermissionsKit
Native permissions framework facilitating collecting users access approval to Camera, Photo Library, Microphone, Contacts, Location, Notifications and Tracking.

<p align="center">
  <img src="https://github.com/macistador/PermissionsKit/blob/main/IconPermissionsKit.png"  width="300" height="300"/>
</p>

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Supported permissions](#Supported_permissions)
- [Usage](#usage)
- [Other packages](#other-packages)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Get permissions status and be notified by changes
- [x] Ask for permissions with built-in pre-prompts 
- [x] Re-engage with built-in re-optins prompts 

<p align="center">
  <img src="https://github.com/macistador/PermissionsKit/blob/main/demo.gif"/>
</p>

## Requirements

- iOS 15.0+
- Xcode 12.0+
- Swift 5.5+

## Installation

### SwiftPackageManager

```swift
dependencies: [
    .package(url: "https://github.com/macistador/PermissionsKit", from: "0.0.4")
]
```

## Supported permissions

- Contacts
- Address book
- Location (always / in use / once)
- Microphone
- Photos Library
- Push Notifications
- Tracking (ATT)


## Usage

### Without built-in prompts

```swift
    let permissionsService = PermissionsService()
        
    // Ask for the permission
    permissionsService.askTrackingPermission()
        
    // Get the permission status
    let trackingPermissionStatus = permissionsService.trackingPermissionStatus
    
    // Know if the permission has been granted previously
    let hasGrantedTrackingPermission = permissionsService.hasGrantedTrackingPermission
```


### With built-in prompts

With __SwiftUI__ as a subview 
```swift
    var permissionsService = PermissionsService()
    var trackingPermissionStatus: TrackingPermissionStatus?
    
    var body: some View {
        VStack {
            if trackingPermissionStatus == .notDetermined {
                PermissionPromptView(.preprompt(reoptinFallback: true), for: permission, title: "Hey there we need this permission!") { hasGrantedPermission in
                    if hasGrantedPermission {
                        trackingPermissionStatus = .granted
                    }
                }
            } else if trackingPermissionStatus == .denied {
                PermissionPromptView(.reoptin, for: permission, title: "Hey there please change your mind!") { hasGrantedPermission in
                    if hasGrantedPermission {
                        trackingPermissionStatus = .granted
                    }
                }
            } else {
                [...]
            }      
        }
        .task {
            trackingPermissionStatus = permissionsService.trackingPermissionStatus
        }
    }
```


With __SwiftUI__ as a modal
```swift
    var permissionsService = PermissionsService()
    @State var showPrepromptForPermission: PermissionsKit.Permission?
    @State var showReoptinForPermission: PermissionsKit.Permission?
    
    var body: some View {
        [...]
        .task {
            let trackingPermissionStatus = permissionsService.trackingPermissionStatus
            if trackingPermissionStatus == .notDetermined {
                showPrepromptForPermission = true
            } else if trackingPermissionStatus == .denied {
                showReoptinForPermission = true
            }
        }
        .sheet(item: $showPrepromptForPermission) { permission in
            PermissionPromptView(.preprompt(reoptinFallback: true), for: permission, title: "Hey there we need this permission!") { hasGrantedPermission in
                showPrepromptForPermission = nil
                if hasGrantedPermission {
                    [...]
                }
            }
        }
        .sheet(item: $showReoptinForPermission) { permission in
            PermissionPromptView(.reoptin, for: permission, title: "Hey there please change your mind!") { hasGrantedPermission in
                showReoptinForPermission = nil
                if hasGrantedPermission {
                    [...]
                }
            }
        }
    }
```

With __UIKit__
```swift
    
    [TBD...]

```


For more details you may take a look at the sample project.

## Other packages

Meanwhile this library works well alone, it is meant to be complementary to the following app bootstrap packages suite: 

- [CoreKit](https://github.com/macistador/CoreKit): Foundation app requirements: Routing, State management, logging...
- [BackendKit](https://github.com/macistador/BackendKit): Handling remote requests, authentication for Firebase / Supabase
- [DesignKit](https://github.com/macistador/DesignKit): DesignSystem
- [VisualKit](https://github.com/macistador/VisualKit): UI components (SwiftUI Views, ViewModifiers)
- [MediasKit](https://github.com/macistador/MediasKit): Loading, caching & displaying Images, Videos, Audios
- [CameraKit](https://github.com/macistador/CameraKit): Capturing photos, videos and audio with effects
- [PermissionsKit](https://github.com/macistador/PermissionsKit): User permissions handling
- [SocialKit](https://github.com/macistador/SocialKit): Share, invite friends
- [CartoKit](https://github.com/macistador/CartoKit): Locate, display maps
- [AnalyzeKit](https://github.com/macistador/AnalyzeKit): Analytics
- [IntelligenceKit](https://github.com/macistador/IntelligenceKit): Integrate embedded AI models
- [AdsKit](https://github.com/macistador/AdsKit): Displaying ads
- [PayKit](https://github.com/macistador/PayKit): Handling paywalls & inApps

## Credits

PermissionsKit is developed and maintained by Michel-André Chirita. You can follow me on Twitter at @Macistador for updates.

## License

PermissionsKit is released under the MIT license. [See LICENSE](https://github.com/macistador/permissionskit/blob/master/LICENSE) for details.
