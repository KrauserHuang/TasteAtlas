//
//  LocationManager.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/27.
//

import MapKit
import Observation

enum LocationError: LocalizedError {
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case network
    case operationFailed
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return NSLocalizedString("Location access denied.", comment: "")
        case .authorizationRestricted:
            return NSLocalizedString("Location access restricted.", comment: "")
        case .unknownLocation:
            return NSLocalizedString("Unknown location.", comment: "")
        case .accessDenied:
            return NSLocalizedString("Access denied.", comment: "")
        case .network:
            return NSLocalizedString("Network failed.", comment: "")
        case .operationFailed:
            return NSLocalizedString("Operation failed.", comment: "")
        }
    }
}

@Observable
final class LocationManager: NSObject {
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    var error: LocationError? = nil
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 任何時候只要authorizationStatus改變就會呼叫這個方法
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            print("Location permission denied")
        case .restricted:
            print("Location permission restricted")
        default:
            break
        }
    }
    // 每次更新位置都會呼叫這個方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .network
            case .locationUnknown:
                self.error = .unknownLocation
            default:
                self.error = .operationFailed
            }
        }
    }
}
