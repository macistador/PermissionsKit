//
//  RequestCameraAccessUseCase.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import AVFoundation

public enum CameraPermissionStatus {
    case accepted
    case notDetermined
    case denied
}

protocol CameraPermissionServiceType {
    func requestIfNeeded() async -> CameraPermissionStatus
    var status: CameraPermissionStatus { get }
}

final class CameraPermissionService: CameraPermissionServiceType {
    
    var status: CameraPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return switch status {
        case .notDetermined: .notDetermined
        case .restricted, .denied: .denied
        case .authorized: .accepted
        @unknown default: .notDetermined
        }
    }
        
    func requestIfNeeded() async -> CameraPermissionStatus {
        guard status == .notDetermined else { return status }
        await AVCaptureDevice.requestAccess(for: .video)
        return status
    }
}
