//
//  TrackingPermissionWorker.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import AppTrackingTransparency

public enum TrackingPermissionStatus {
    /** The user has granted the access. */
    case authorized
    /** The user hasn't granted the access. */
    case denied
    /** The user's device is restricted. */
    case restricted
    /** Should ask for permission. */
    case notDetermined
    /** The device's version is less than 14.0 */
    case notAvailable
    /** A new status has been added but is not handled at the moment. */
    case unknown
}

protocol TrackingPermissionServiceType {
    var status: TrackingPermissionStatus { get }
    func requestTrackingPermission() async -> TrackingPermissionStatus
}

final class TrackingPermissionService: TrackingPermissionServiceType {
    
    var status: TrackingPermissionStatus {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return switch status {
            case .authorized: .authorized
            case .denied: .denied
            case .restricted: .restricted
            case .notDetermined: .notDetermined
            @unknown default: .unknown
            }
        } else {
            return .notAvailable
        }
    }
    
    func requestTrackingPermission() async -> TrackingPermissionStatus {
        if #available(iOS 14, *) {
            await ATTrackingManager.requestTrackingAuthorization()
            return self.status
        } else {
            return .notAvailable
        }
    }
}
