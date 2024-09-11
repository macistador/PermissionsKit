//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation

public protocol PermissionsWorker {
    func hasAllMandatoryPermissions() async -> Bool

    var notificationsPermissionStatus: PushNotificationPermissionStatus { get async }
    var hasGrantedNotificationPermission: Bool { get async }
    func askNotificationPermission() async -> Bool
    
    var cameraPermissionStatus: CameraPermissionStatus { get }
    var hasGrantedCameraPermission: Bool { get }
    func askCameraPermission() async -> Bool
    
    var contactsPermissionStatus: AddressBookPermissionStatus { get }
    var hasGrantedContactsPermission: Bool { get }
    func askContactsPermission() async -> Bool
    
    var photoAlbumPermissionStatus: PhotoGaleryPermissionStatus { get }
    var hasGrantedPhotoAlbumPermission: Bool { get }
    func askPhotoAlbumPermission() async -> Bool
    
    var attPermissionStatus: TrackingPermissionStatus { get }
    var hasGrantedAttPermission: Bool { get }
    @discardableResult
    func askAttPermission() async -> Bool
}

public final class PermissionsWorkerImpl: PermissionsWorker {
    
    private var pushNotificationPermissionService = PushNotificationPermissionServiceImpl()
    private var trackingPermissionService = TrackingPermissionServiceImpl()
    private var addressBookPermissionService = AddressBookPermissionServiceImpl()
    private var cameraPermissionService = CameraPermissionServiceImpl()
    private var photoGalleryPermissionService = PhotoGalleryPermissionServiceImpl()

    public func hasAllMandatoryPermissions() async -> Bool {
        let push = await hasGrantedNotificationPermission
        return (hasGrantedCameraPermission && hasGrantedContactsPermission && push)
    }
    
    // MARK: - Push Notifications

    public var notificationsPermissionStatus: PushNotificationPermissionStatus { get async { await pushNotificationPermissionService.status } }
    public var hasGrantedNotificationPermission: Bool { get async { await pushNotificationPermissionService.status == .authorized } }
    
    public func askNotificationPermission() async -> Bool {
        await pushNotificationPermissionService.askForPushPermission() == .authorized
    }
    
    // MARK: - Camera

    public var cameraPermissionStatus: CameraPermissionStatus { cameraPermissionService.status }
    public var hasGrantedCameraPermission: Bool { cameraPermissionService.status == .accepted }
    
    public func askCameraPermission() async -> Bool {
        await cameraPermissionService.requestIfNeeded() == .accepted
    }
    
    
    // MARK: - Contacts (Address Book)
    
    public var contactsPermissionStatus: AddressBookPermissionStatus { addressBookPermissionService.status }
    public var hasGrantedContactsPermission: Bool { addressBookPermissionService.status == .accepted }
        
    public func askContactsPermission() async -> Bool {
        await addressBookPermissionService.requestIfNeeded() == .accepted
    }
    
    // MARK: - Photo album

    public var photoAlbumPermissionStatus: PhotoGaleryPermissionStatus { photoGalleryPermissionService.status }
    public var hasGrantedPhotoAlbumPermission: Bool { photoGalleryPermissionService.status == .accepted }
    
    public func askPhotoAlbumPermission() async -> Bool {
        await photoGalleryPermissionService.requestIfNeeded() == .accepted
    }
    
    // MARK: - Tracking (ATT)
    
    public var attPermissionStatus: TrackingPermissionStatus { trackingPermissionService.status }
    public var hasGrantedAttPermission: Bool { trackingPermissionService.status == .authorized }
    
    @discardableResult
    public func askAttPermission() async -> Bool {
        await trackingPermissionService.requestTrackingPermission() == .authorized
    }
}
