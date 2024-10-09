//
//  PhotoGalleryPermissionService.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation
import Photos

public enum PhotoLibraryPermissionStatus {
    case accepted
    case notDetermined
    case denied
}

protocol PhotoLibraryPermissionServiceType {
    var status: PhotoLibraryPermissionStatus { get }
    func requestIfNeeded() async -> PhotoLibraryPermissionStatus
}

final class PhotoLibraryPermissionService: PhotoLibraryPermissionServiceType {
    
    var status: PhotoLibraryPermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return switch status {
        case .notDetermined: .notDetermined
        case .restricted, .denied: .denied
        case .authorized, .limited: .accepted
        @unknown default: .notDetermined
        }
    }

    func requestIfNeeded() async -> PhotoLibraryPermissionStatus {
        _ = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        return self.status
    }
}
