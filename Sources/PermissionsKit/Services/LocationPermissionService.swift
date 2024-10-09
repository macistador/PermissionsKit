//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 20/09/2024.
//

import Foundation
import CoreLocation

public enum LocationPermissionStatus {
    case acceptedAlways
    case acceptedInUse
    case acceptedOnce
    case notDetermined
    case denied
}

public enum LocationPermissionUsage {
    case always
    case inUse
    case oneTime
}

protocol LocationPermissionServiceType {
    func requestIfNeeded(for usage: LocationPermissionUsage, completion: @escaping (LocationPermissionStatus)->Void)
    var status: LocationPermissionStatus { get }
}

final class LocationPermissionService: NSObject, LocationPermissionServiceType, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager
    private var completion: ((LocationPermissionStatus)->Void)?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    var status: LocationPermissionStatus {
        let status = locationManager.authorizationStatus
        return switch status {
        case .notDetermined: .notDetermined
        case .restricted, .denied: .denied
        case .authorizedAlways: .acceptedAlways
        case .authorizedWhenInUse: .acceptedInUse
        case .authorized: .acceptedOnce
        @unknown default: .notDetermined
        }
    }
        
    func requestIfNeeded(for usage: LocationPermissionUsage, completion: @escaping (LocationPermissionStatus)->Void) {
        guard status == .notDetermined else {
            completion(status)
            return
        }
        self.completion = completion
        DispatchQueue.main.async {
            switch usage {
            case .always: self.locationManager.requestAlwaysAuthorization()
            case .inUse: self.locationManager.requestWhenInUseAuthorization()
            case .oneTime: self.locationManager.requestLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        completion?(self.status)
        completion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        completion?(self.status)
        completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completion?(self.status)
        completion = nil
    }
}
