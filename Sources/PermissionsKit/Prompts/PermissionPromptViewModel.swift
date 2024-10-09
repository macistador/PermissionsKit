//
//  PermissionPrepromptViewModel.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation
import UIKit
import Combine

final class PermissionPromptViewModel: ObservableObject {
        
    @Published var permission: Permission
    @Published var promptKind: PromptKind
    var completion: ((Bool) -> ())? = nil
    var shouldFallbackToReoptin: Bool {
        switch promptKind {
        case .preprompt(let reoptinFallback): reoptinFallback
        case .reoptin: false
        }
    }
    private var permissionsWorker: PermissionsServiceType = PermissionsService()
    private var cancellables: [AnyCancellable] = []
    
    init(permission: Permission, promptKind: PromptKind, completion: ((Bool) -> ())? = nil) {
        self.permission = permission
        self.promptKind = promptKind
        self.completion = completion
    }
    
    // MARK: - View interactions
    
    func shouldClosePrompt() async -> Bool {
        switch permission {
        case .pushNotification:
            await self.permissionsWorker.hasGrantedNotificationPermission
        case .camera:
            self.permissionsWorker.hasGrantedCameraPermission
        case .photoLibrary:
            self.permissionsWorker.hasGrantedPhotoLibraryPermission
        case .contacts:
            self.permissionsWorker.hasGrantedContactsPermission
        case .tracking:
            self.permissionsWorker.hasGrantedTrackingPermission
        case .microphone:
            self.permissionsWorker.hasGrantedMicrophonePermission
        case .location:
            self.permissionsWorker.hasGrantedLocationPermission
        }
    }
    
    func redirectToPermissionSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    func showPermissionPrompt() async -> Bool {
        switch permission {
        case .pushNotification:
            await self.permissionsWorker.askNotificationPermission()
        case .camera:
            await self.permissionsWorker.askCameraPermission()
        case .photoLibrary:
            await self.permissionsWorker.askPhotoLibraryPermission()
        case .contacts:
            await self.permissionsWorker.askContactsPermission()
        case .tracking:
            await self.permissionsWorker.askTrackingPermission()
        case .microphone:
            await self.permissionsWorker.askMicrophonePermission()
        case .location(let usage):
            await self.permissionsWorker.askLocationPermission(for: usage)
        }
    }
}
