//
//  PushNotificationPermissionWorker.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import UIKit
import Foundation

public enum PushNotificationPermissionStatus {
    case notDetermined
    case denied
    case authorized
    case unknown
}

protocol PushNotificationPermissionService {
    var status: PushNotificationPermissionStatus { get async }
    func askForPushPermission() async -> PushNotificationPermissionStatus
}

final class PushNotificationPermissionServiceImpl: PushNotificationPermissionService {

    private let notificationCenter = UNUserNotificationCenter.current()
    private var currentStatus: PushNotificationPermissionStatus? = nil
    
    var status: PushNotificationPermissionStatus {
        get async {
            let settings = await self.notificationCenter.notificationSettings()
            return self.handleAuthorizationStatus(settings.authorizationStatus)
        }
    }
    
    func askForPushPermission() async -> PushNotificationPermissionStatus {
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        do {
            let success = try await self.notificationCenter.requestAuthorization(options: authorizationOptions)
            return await MainActor.run {
                UIApplication.shared.registerForRemoteNotifications()
//                self?.currentStatus = success ? .authorized : .denied
                return success ? PushNotificationPermissionStatus.authorized : PushNotificationPermissionStatus.denied
            }
        }
        catch {
            self.currentStatus = .unknown
            return .unknown
        }
    }


    // MARK: - Private functions

    private func handleAuthorizationStatus(_ authorizationStatus: UNAuthorizationStatus) -> PushNotificationPermissionStatus {
        let status: PushNotificationPermissionStatus

        switch authorizationStatus {
        case .denied:
            status = .denied
        case .authorized, .ephemeral, .provisional:
            status = .authorized
        case .notDetermined:
            status = .notDetermined
        @unknown default:
            status = .unknown
        }

        self.currentStatus = status
        return status
    }

}
