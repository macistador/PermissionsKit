//
//  AdressBookPermissionWorker.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import Foundation
import Contacts
import Foundation

public enum AddressBookPermissionStatus {
    case accepted
    case notDetermined
    case refused
}

protocol AddressBookPermissionService {
    var status: AddressBookPermissionStatus { get }
    func requestIfNeeded() async -> AddressBookPermissionStatus
}

final class AddressBookPermissionServiceImpl: AddressBookPermissionService {
    
    var status: AddressBookPermissionStatus {
        return switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .limited: .accepted
        case .denied, .restricted: .refused
        case .notDetermined: .notDetermined
        @unknown default: .notDetermined
        }
    }
    
    func requestIfNeeded() async -> AddressBookPermissionStatus {
        guard CNContactStore.authorizationStatus(for: .contacts) == .notDetermined else {
            return status
        }
        
        do {
            _ = try await CNContactStore().requestAccess(for: .contacts)
            return status
        } catch {
            return .notDetermined
        }
    }
}
