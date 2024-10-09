//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI
import Combine

@MainActor
final class MultiPermissionsViewModel: ObservableObject {
    
    final class PermissionState: Identifiable, ObservableObject {
        let id: String
        let permission: Permission
        @Published var hasGranted: Bool = false
        init(permission: Permission) {
            self.id = permission.title
            self.permission = permission
        }
    }
    
    @Published var permissionsStates: [PermissionState]
    @Published var nextButtonState: PromptButton.State = .disabled
    @Published var showGoToDeviceSettingsAlert: Bool = false
    private var permissionsService: PermissionsServiceType = PermissionsService()
    private var cancellables: [AnyCancellable] = []
            
    init(permissions: [Permission]) {
        self.permissionsStates = permissions.map {
            PermissionState(permission: $0)
        }
        
        Task {
            await setInitialPermissionsStatus()
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
                guard let self else { return }
                Task {
                    await self.setInitialPermissionsStatus()
                }
            }
        }
    }
    
    // MARK: - Private functions
    
    private func setInitialPermissionsStatus() async {
        var updatedPermissionsStates: [PermissionState] = []
        
        for permissionsState in permissionsStates {
            var permissionsState = permissionsState
            let hasGranted: Bool
            
            switch permissionsState.permission {
            case .pushNotification: hasGranted = await permissionsService.hasGrantedNotificationPermission
            case .camera: hasGranted = permissionsService.hasGrantedCameraPermission
            case .photoLibrary: hasGranted = permissionsService.hasGrantedPhotoLibraryPermission
            case .contacts: hasGranted = permissionsService.hasGrantedContactsPermission
            case .tracking: hasGranted = permissionsService.hasGrantedTrackingPermission
            case .microphone: hasGranted = permissionsService.hasGrantedMicrophonePermission
            case .location(let usage): hasGranted = permissionsService.hasGrantedLocationPermission
            }
            
            permissionsState.hasGranted = hasGranted
            updatedPermissionsStates.append(permissionsState)
        }


        await MainActor.run {
            self.permissionsStates = updatedPermissionsStates
            stateChangeBindings()
            validationBindings()
        }
    }
    
    private func updateBindings(for permissionState: PermissionState) {
        validationBinding(for: permissionState)
        stateChangeBinding(for: permissionState)
    }
    
    private func stateChangeBindings() {
        for permissionsState in permissionsStates {
            stateChangeBinding(for: permissionsState)
        }
    }
    
    private func validationBindings() {        
        for permissionsState in permissionsStates {
            validationBinding(for: permissionsState)
        }
    }
    
    private func stateChangeBinding(for permissionState: PermissionState) {
        permissionState.$hasGranted
            .receive(on: RunLoop.main)
            .sink { [unowned self] hasGranted in
                guard hasGranted else { return }
                
                switch permissionState.permission {
                case .pushNotification:
                    Task {
                        let currentStatus = await permissionsService.notificationsPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askNotificationPermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                        
                case .camera:
                    Task {
                        let currentStatus = await permissionsService.cameraPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askCameraPermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                    
                case .photoLibrary:
                    Task {
                        let currentStatus = await permissionsService.photoLibraryPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askPhotoLibraryPermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                    
                case .contacts:
                    Task {
                        let currentStatus = permissionsService.contactsPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askContactsPermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }

                case .tracking:
                    Task {
                        let currentStatus = await permissionsService.trackingPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askTrackingPermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                    
                case .microphone:
                    Task {
                        let currentStatus = await permissionsService.microphonePermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askMicrophonePermission()
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                    
                case .location(let usage):
                    Task {
                        let currentStatus = await permissionsService.locationPermissionStatus
                        if currentStatus == .notDetermined {
                            let hasAccepted = await self.permissionsService.askLocationPermission(for: usage)
                            await MainActor.run {
                                updateStatus(for: permissionState.permission, to: hasAccepted)
                            }
                        }
                        else if currentStatus == .denied {
                            await MainActor.run {
                                self.showGoToDeviceSettingsAlert = true
                                updateStatus(for: permissionState.permission, to: false)
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
        
    private func validationBinding(for permissionState: PermissionState) {
        permissionState.$hasGranted
            .receive(on: RunLoop.main)
            .map { [weak self] hasGranted in
                guard let self else { return .disabled }
                let allGranted = self.permissionsStates.allSatisfy { $0.hasGranted == true }
                return allGranted ? .enabled : .disabled
            }
            .assign(to: &$nextButtonState)
    }
    
    private func updateStatus(for permission: Permission, to isGranted: Bool) {
        var newPermissionState = PermissionState(permission: permission)
        newPermissionState.hasGranted = isGranted
        guard let index = permissionsStates.firstIndex(where: { $0.id == newPermissionState.id }) else { return }
        permissionsStates.remove(at: index)
        permissionsStates.insert(newPermissionState, at: index)
        updateBindings(for: newPermissionState)
    }
    
    // MARK: - Routing

    func redirectToPermissionSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - AppTrackingTransparency
    
    private func requestTrackingPermission() {
        Task {
            _ = await permissionsService.askTrackingPermission()
        }
    }
}
