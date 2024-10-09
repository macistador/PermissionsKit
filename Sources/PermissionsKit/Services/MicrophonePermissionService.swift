//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 20/09/2024.
//

import AVFoundation

public enum MicrophonePermissionStatus {
    case accepted
    case notDetermined
    case denied
}

protocol MicrophonePermissionServiceType {
    func requestIfNeeded() async -> MicrophonePermissionStatus
    var status: MicrophonePermissionStatus { get }
}

final class MicrophonePermissionService: MicrophonePermissionServiceType {
    
    var status: MicrophonePermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        return switch status {
        case .notDetermined: .notDetermined
        case .restricted, .denied: .denied
        case .authorized: .accepted
        @unknown default: .notDetermined
        }
    }
        
    func requestIfNeeded() async -> MicrophonePermissionStatus {
        guard status == .notDetermined else { return status }
        await AVCaptureDevice.requestAccess(for: .audio)
        return status
    }
}
