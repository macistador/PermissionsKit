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
    
    enum Permission {
        case pushNotification
        case camera
        case photoGallery
        case contacts
        case att
        
        var title: String {
            switch self {
            case .pushNotification: "Notifications"
            case .camera: "Camera"
            case .photoGallery: "Photo gallery"
            case .contacts: "Contacts"
            case .att: "Tracking"
            }
        }
        
        var icon: ImageResource {
            switch self {
            case .pushNotification: .iconPushNotifications
            case .camera: .iconCamera
            case .photoGallery: .iconGalleryPhoto
            case .contacts: .iconContacts
            case .att: .iconAtt2
            }
        }
    }
    
    enum PromptKind {
        case preprompt
        case reoptin
    }
    
    enum Source {
        case invitations
        case other
    }
    
    @Published var permission: Permission
    @Published var promptKind: PromptKind
//    @Published var source: Source
    private var permissionsWorker: PermissionsWorker = PermissionsWorkerImpl()
    private var cancellables: [AnyCancellable] = []
    
    init(permission: Permission, promptKind: PromptKind, source: Source = .other) {
        self.permission = permission
        self.promptKind = promptKind
//        self.source = source
    }
    
    // MARK: - View interactions
    
    func shouldClosePrompt() async -> Bool {
        switch permission {
        case .pushNotification:
            await self.permissionsWorker.hasGrantedNotificationPermission
        case .camera:
            self.permissionsWorker.hasGrantedCameraPermission
        case .photoGallery:
            self.permissionsWorker.hasGrantedPhotoAlbumPermission
        case .contacts:
            self.permissionsWorker.hasGrantedContactsPermission
        case .att:
            self.permissionsWorker.hasGrantedAttPermission
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
        case .photoGallery:
            await self.permissionsWorker.askPhotoAlbumPermission()
        case .contacts:
            await self.permissionsWorker.askContactsPermission()
        case .att:
            await self.permissionsWorker.askAttPermission()
        }
    }
}
