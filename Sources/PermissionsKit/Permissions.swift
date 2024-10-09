//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 12/09/2024.
//

import Foundation
import UIKit

public enum Permission: Equatable {
    case pushNotification
    case camera
    case photoLibrary
    case contacts
    case tracking
    case microphone
    case location(usage: LocationPermissionUsage)
    
    public var title: String {
        switch self {
        case .pushNotification: "Notifications"
        case .camera: "Camera"
        case .photoLibrary: "Photo library"
        case .contacts: "Contacts"
        case .tracking: "Tracking"
        case .microphone: "Microphone"
        case .location: "Location"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .pushNotification: .iconPushNotifications
        case .camera: .iconCamera
        case .photoLibrary: .iconGalleryPhoto
        case .contacts: .iconContacts
        case .tracking: .iconAtt
        case .microphone: .iconMicrophone
        case .location: .iconLocation
        }
    }
    
    var images: [ImageResource] {
        switch self {
        case .pushNotification: []
        case .camera: [.photo1, .photo2, .photo3, .photo4, .photo5]
        case .photoLibrary: [.photo1, .photo2, .photo3, .photo4, .photo5]
        case .contacts: [.mockUserPicture3, .mockUserPicture4, .mockUserPicture1, .mockUserPicture2]
        case .tracking: []
        case .microphone: []
        case .location: []
        }
    }

    
    var isPushNotification: Bool {
        switch self {
        case .pushNotification: true
        default: false
        }
    }
    
    var isCamera: Bool {
        switch self {
        case .camera: true
        default: false
        }
    }
    
    var isPhotoLibrary: Bool {
        switch self {
        case .photoLibrary: true
        default: false
        }
    }
    
    var isContacts: Bool {
        switch self {
        case .contacts: true
        default: false
        }
    }
    
    var isTracking: Bool {
        switch self {
        case .tracking: true
        default: false
        }
    }
    
    var isMic: Bool {
        switch self {
        case .microphone: true
        default: false
        }
    }
    
    var isLocation: Bool {
        switch self {
        case .location: true
        default: false
        }
    }
}
