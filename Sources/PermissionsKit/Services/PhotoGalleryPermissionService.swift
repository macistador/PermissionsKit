//
//  PhotoGalleryPermissionService.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation
import Photos

public enum PhotoGaleryPermissionStatus {
    case accepted
    case notDetermined
    case refused
}

protocol PhotoGalleryPermissionService {
    var status: PhotoGaleryPermissionStatus { get }
    func requestIfNeeded() async -> PhotoGaleryPermissionStatus
}

final class PhotoGalleryPermissionServiceImpl: PhotoGalleryPermissionService {
    
    var status: PhotoGaleryPermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return switch status {
        case .notDetermined: .notDetermined
        case .restricted, .denied: .refused
        case .authorized, .limited: .accepted
        @unknown default: .notDetermined
        }
    }

    func requestIfNeeded() async -> PhotoGaleryPermissionStatus {
        _ = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        return self.status
    }
}
