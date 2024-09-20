//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation

public protocol PermissionsServiceType {
    func hasAllMandatoryPermissions() async -> Bool

    var notificationsPermissionStatus: PushNotificationPermissionStatus { get async }
    var hasGrantedNotificationPermission: Bool { get async }
    @discardableResult
    func askNotificationPermission() async -> Bool
    
    var cameraPermissionStatus: CameraPermissionStatus { get }
    var hasGrantedCameraPermission: Bool { get }
    @discardableResult
    func askCameraPermission() async -> Bool
    
    var contactsPermissionStatus: AddressBookPermissionStatus { get }
    var hasGrantedContactsPermission: Bool { get }
    @discardableResult
    func askContactsPermission() async -> Bool
    
    var photoLibraryPermissionStatus: PhotoLibraryPermissionStatus { get }
    var hasGrantedPhotoLibraryPermission: Bool { get }
    @discardableResult
    func askPhotoLibraryPermission() async -> Bool
    
    var microphonePermissionStatus: MicrophonePermissionStatus { get }
    var hasGrantedMicrophonePermission: Bool { get }
    @discardableResult
    func askMicrophonePermission() async -> Bool

    var locationPermissionStatus: LocationPermissionStatus { get }
    var hasGrantedLocationPermission: Bool { get }
    @discardableResult
    func askLocationPermission(for usage: LocationPermissionUsage) async -> Bool

    var trackingPermissionStatus: TrackingPermissionStatus { get }
    var hasGrantedTrackingPermission: Bool { get }
    @discardableResult
    func askTrackingPermission() async -> Bool
}

public final class PermissionsService: PermissionsServiceType {
    
    private var pushNotificationPermissionService = PushNotificationPermissionService()
    private var trackingPermissionService = TrackingPermissionService()
    private var addressBookPermissionService = AddressBookPermissionService()
    private var cameraPermissionService = CameraPermissionService()
    private var photoLibraryPermissionService = PhotoLibraryPermissionService()
    private var microphonePermissionService = MicrophonePermissionService()
    private var locationPermissionService = LocationPermissionService()

    public init() {}
    
    public func hasAllMandatoryPermissions() async -> Bool {
        let push = await hasGrantedNotificationPermission
        return (hasGrantedCameraPermission && hasGrantedContactsPermission && push)
    }
    
    // MARK: - Push Notifications

    public var notificationsPermissionStatus: PushNotificationPermissionStatus { get async { await pushNotificationPermissionService.status } }
    public var hasGrantedNotificationPermission: Bool { get async { await pushNotificationPermissionService.status == .authorized } }
    
    @discardableResult
    public func askNotificationPermission() async -> Bool {
        await pushNotificationPermissionService.askForPushPermission() == .authorized
    }
    
    // MARK: - Camera

    public var cameraPermissionStatus: CameraPermissionStatus { cameraPermissionService.status }
    public var hasGrantedCameraPermission: Bool { cameraPermissionService.status == .accepted }
    
    @discardableResult
    public func askCameraPermission() async -> Bool {
        await cameraPermissionService.requestIfNeeded() == .accepted
    }
    
    
    // MARK: - Contacts (Address Book)
    
    public var contactsPermissionStatus: AddressBookPermissionStatus { addressBookPermissionService.status }
    public var hasGrantedContactsPermission: Bool { addressBookPermissionService.status == .accepted }
        
    @discardableResult
    public func askContactsPermission() async -> Bool {
        await addressBookPermissionService.requestIfNeeded() == .accepted
    }
    
    // MARK: - Photo library

    public var photoLibraryPermissionStatus: PhotoLibraryPermissionStatus { photoLibraryPermissionService.status }
    public var hasGrantedPhotoLibraryPermission: Bool { photoLibraryPermissionService.status == .accepted }
    
    @discardableResult
    public func askPhotoLibraryPermission() async -> Bool {
        await photoLibraryPermissionService.requestIfNeeded() == .accepted
    }
    
    // MARK: - Microphone

    public var microphonePermissionStatus: MicrophonePermissionStatus { microphonePermissionService.status }
    public var hasGrantedMicrophonePermission: Bool { microphonePermissionService.status == .accepted }
    
    @discardableResult
    public func askMicrophonePermission() async -> Bool {
        await microphonePermissionService.requestIfNeeded() == .accepted
    }

    
    // MARK: - Location

    public var locationPermissionStatus: LocationPermissionStatus { locationPermissionService.status }
    public var hasGrantedLocationPermission: Bool { [.acceptedAlways, .acceptedInUse, .acceptedOnce].contains(locationPermissionService.status) }
    
    @discardableResult
    public func askLocationPermission(for usage: LocationPermissionUsage) async -> Bool {
        return await withCheckedContinuation { contination in
            locationPermissionService.requestIfNeeded(for: usage, completion: { status in
                let hasGrantedUsage: Bool
                switch usage {
                case .always: hasGrantedUsage = status == .acceptedAlways
                case .inUse: hasGrantedUsage = status == .acceptedInUse
                case .oneTime: hasGrantedUsage = status == .acceptedOnce
                }
                contination.resume(returning: hasGrantedUsage)
            })
        }
    }
    
    // MARK: - Tracking (ATT)
    
    public var trackingPermissionStatus: TrackingPermissionStatus { trackingPermissionService.status }
    public var hasGrantedTrackingPermission: Bool { trackingPermissionService.status == .authorized }
    
    @discardableResult
    public func askTrackingPermission() async -> Bool {
        await trackingPermissionService.requestTrackingPermission() == .authorized
    }
}
