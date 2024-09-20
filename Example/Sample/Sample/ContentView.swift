//
//  ContentView.swift
//  Sample
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI
import PermissionsKit

struct ContentView: View {
    
    private let permissionsService: PermissionsServiceType = PermissionsService()
    @State private var notificationPermissionStatus: PushNotificationPermissionStatus?
    @State private var cameraPermissionStatus: CameraPermissionStatus?
    @State private var photoLibraryPermissionStatus: PhotoLibraryPermissionStatus?
    @State private var contactsPermissionStatus: AddressBookPermissionStatus?
    @State private var trackingPermissionStatus: TrackingPermissionStatus?
    @State private var microphonePermissionStatus: MicrophonePermissionStatus?
    @State private var locationPermissionStatus: LocationPermissionStatus?
    @State private var showPrepromptForPermission: PermissionsKit.Permission?
    @State private var showReoptinForPermission: PermissionsKit.Permission?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                permissionView(for: .camera)
                permissionView(for: .contacts)
                permissionView(for: .pushNotification)
                permissionView(for: .photoLibrary)
                permissionView(for: .location(usage: .inUse))
                permissionView(for: .tracking)
                permissionView(for: .microphone)
            }
            .padding()
        }
        .task {
            await fetchPermissionsStatus()
        }
        .sheet(item: $showPrepromptForPermission) { permission in
            PermissionPromptView(.preprompt(reoptinFallback: true), for: permission, title: "Hey there we need this permission!") { hasGrantedPermission in
                showPrepromptForPermission = nil
                Task {
                    await fetchPermissionsStatus()
                }
            }
        }
        .sheet(item: $showReoptinForPermission) { permission in
            PermissionPromptView(.reoptin, for: permission, title: "Hey there please change your mind!") { hasGrantedPermission in
                showReoptinForPermission = nil
                Task {
                    await fetchPermissionsStatus()
                }
            }
        }
    }
        
    @ViewBuilder
    func permissionView(for permission: Permission) -> some View {
        HStack {
            Text(permission.title)
                .font(.largeTitle)
            Spacer()
            Text(emojiStatus(for: permission))
        }
        HStack {
            prepromptButton(for: permission)
                .disabled(hasBeenPrompted(for: permission))
            reoptinButton(for: permission)
                .disabled(isNotDenied(for: permission))
            askPermissionButton(for: permission)
                .disabled(hasBeenPrompted(for: permission))
        }
        Divider()
    }
    
    @ViewBuilder
    private func prepromptButton(for permission: PermissionsKit.Permission) -> some View {
        Button {
            showPrepromptForPermission = permission
        } label: {
            Text("Preprompt")
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    @ViewBuilder
    private func reoptinButton(for permission: PermissionsKit.Permission) -> some View {
        Button {
            showReoptinForPermission = permission
        } label: {
            Text("Reoptin")
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    @ViewBuilder
    private func askPermissionButton(for permission: PermissionsKit.Permission) -> some View {
        Button {
            Task {
                switch permission {
                case .tracking: await permissionsService.askTrackingPermission()
                case .camera: await permissionsService.askCameraPermission()
                case .contacts: await permissionsService.askContactsPermission()
                case .photoLibrary: await permissionsService.askPhotoLibraryPermission()
                case .pushNotification: await permissionsService.askNotificationPermission()
                case .microphone: await permissionsService.askMicrophonePermission()
                case .location: await permissionsService.askLocationPermission(for: .inUse)
                }
                await fetchPermissionsStatus()
            }
        } label: {
            Text("Direct ask")
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    // MARK: - Private methods
    
    private func fetchPermissionsStatus() async {
        notificationPermissionStatus = await permissionsService.notificationsPermissionStatus
        cameraPermissionStatus = permissionsService.cameraPermissionStatus
        photoLibraryPermissionStatus = permissionsService.photoLibraryPermissionStatus
        contactsPermissionStatus = permissionsService.contactsPermissionStatus
        trackingPermissionStatus = permissionsService.trackingPermissionStatus
        microphonePermissionStatus = permissionsService.microphonePermissionStatus
        locationPermissionStatus = permissionsService.locationPermissionStatus
    }
    
    private func hasBeenPrompted(for permission: Permission) -> Bool {
        switch permission {
        case .pushNotification: notificationPermissionStatus != .notDetermined
        case .camera: cameraPermissionStatus != .notDetermined
        case .photoLibrary: photoLibraryPermissionStatus != .notDetermined
        case .contacts: contactsPermissionStatus != .notDetermined
        case .tracking: trackingPermissionStatus != .notDetermined
        case .microphone: microphonePermissionStatus != .notDetermined
        case .location: locationPermissionStatus != .notDetermined
        }
    }
    
    private func isNotDenied(for permission: Permission) -> Bool {
        switch permission {
        case .pushNotification: notificationPermissionStatus != .denied
        case .camera: cameraPermissionStatus != .denied
        case .photoLibrary: photoLibraryPermissionStatus != .denied
        case .contacts: contactsPermissionStatus != .denied
        case .tracking: trackingPermissionStatus != .denied
        case .microphone: microphonePermissionStatus != .denied
        case .location: locationPermissionStatus != .denied
        }
    }
    
    private func emojiStatus(for permission: Permission) -> String {
        switch permission {
        case .pushNotification:
            return switch notificationPermissionStatus {
            case .authorized: "🟢"
            case .notDetermined, .unknown: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
            
        case .camera:
            return switch cameraPermissionStatus {
            case .accepted: "🟢"
            case .notDetermined: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
            
        case .photoLibrary:
            return switch photoLibraryPermissionStatus {
            case .accepted: "🟢"
            case .notDetermined: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
            
        case .contacts:
            return switch contactsPermissionStatus {
            case .accepted: "🟢"
            case .notDetermined: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
            
        case .tracking:
            return switch trackingPermissionStatus {
            case .authorized: "🟢"
            case .notDetermined,.notAvailable, .unknown: "⚪️"
            case .denied, .restricted: "🔴"
            case .none: ""
            }
            
        case .microphone:
            return switch microphonePermissionStatus {
            case .accepted: "🟢"
            case .notDetermined: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
            
        case .location(usage: let usage):
            return switch locationPermissionStatus {
            case .acceptedAlways: usage == .always ? "🟢" : "🔴"
            case .acceptedInUse: usage == .inUse ? "🟢" : "🔴"
            case .acceptedOnce: usage == .oneTime ? "🟢" : "🔴"
            case .notDetermined: "⚪️"
            case .denied: "🔴"
            case .none: ""
            }
        }
    }
}

#Preview {
    ContentView()
}


extension Permission: @retroactive Identifiable {
    public var id: String { self.description }
}

extension Permission: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .pushNotification: "pushNotification"
        case .camera: "camera"
        case .photoLibrary: "photoLibrary"
        case .contacts: "contacts"
        case .tracking: "tracking"
        case .microphone: "microphone"
        case .location(let usage):
            switch usage {
            case .always: "location" + "always"
            case .inUse: "location" + "inUse"
            case .oneTime: "location" + "oneTime"
            }
        }
    }
}
