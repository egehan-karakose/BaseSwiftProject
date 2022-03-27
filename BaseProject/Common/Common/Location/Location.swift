//
//  Location.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import CoreLocation

// This class should be extend NSObject to get benefits of CLLocationManagerDelegate.
public final class Location: NSObject {
    
    public typealias LocationListener = ((CLLocationCoordinate2D?) -> Void)
    private var authListener: LocationAuthHandler?
    
    // Private location manager
    private var locationManager: CLLocationManager!
    private var settingsAlert: AlertCarrier?
    
    private var listeners: [LocationListener]?
    private var isRequesting: Bool = false
    
    private var lastKnownLocation: CLLocation?
    private lazy var geocoder = CLGeocoder()
    
    public var lastSucceedCoordinate: CLLocationCoordinate2D? {
        didSet {
            guard let lastSucceedCoordinate = lastSucceedCoordinate else { return }
            listeners?.forEach({ $0(lastSucceedCoordinate) })
            LocationUtils.shared.lastSucceedCoordinate = lastSucceedCoordinate
        }
    }
    
    private var succeedCoordinate: CLLocationCoordinate2D? {
        get {
            return lastSucceedCoordinate
        }
        set {
            guard let newValue = newValue else { return }
            guard let lastSucceedCoordinate = lastSucceedCoordinate else {
                self.lastSucceedCoordinate = newValue
                return
            }
            if newValue.latitude != lastSucceedCoordinate.latitude {
                self.lastSucceedCoordinate = newValue
            } else if newValue.longitude != lastSucceedCoordinate.longitude {
                self.lastSucceedCoordinate = newValue
            }
        }
    }
    
    public override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
    }
}

// MARK: - Public Helpers

public extension Location {
    // Returns if device has the location settings is on or vise versa.
    // Device's location information.
    var isEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    // Returns application's location status. Not device's!
    var isPermitted: Bool {
        let isPermittedWhenInUse = authStatus == .authorizedWhenInUse
        let isPermittedAlways = authStatus == .authorizedAlways
        return isPermittedWhenInUse || isPermittedAlways
    }
    
    // Returns application's location status. Not device's!
    var isDenied: Bool {
        return authStatus == .denied
    }
    
    // MARK: - Information Area
    
    func request() {
        if isPermitted || isDenied {
            isRequesting = false
            return
        }
        isRequesting = true
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Management
    
    func observe(_ listener: @escaping LocationListener) {
        if var listeners = listeners {
            listeners.append(listener)
        } else {
            listeners = []
            listeners?.append(listener)
        }
    }
    
    func resetAll() {
        authListener = nil
        listeners?.removeAll()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func setAuthListener(action: @escaping LocationAuthHandler) {
        authListener = action
    }

}

// MARK: - Private Helpers

private extension Location {
    
    var authStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    // swiftlint:disable line_length
    func createSettingsAlert() {
        if isRequesting { return }
        let cancelAction = AlertActionHandler(title: "Vazgeç".localized, type: 1, handler: nil)
        let doneAction = AlertActionHandler(title: "AYARLAR".localized, type: 0, handler: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        settingsAlert = AlertCarrier(title: "Konum İzni".localized, message: "Konum izni için ayarlardan konum paylaşımına onay vermeniz gerekmektedir.".localized, actions: [cancelAction, doneAction])
    }
    // swiftlint:enable line_length
    
    func getLocationDetails(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil { return }
            if let country = placemarks?.first?.country {
                LocationUtils.shared.country = country
            }
            if let locationDetails = placemarks?.first?.addressDictionary {
                LocationUtils.shared.locationDetails = locationDetails
            }
            
            if let isoCountryCode = placemarks?.first?.isoCountryCode {
                LocationUtils.shared.countryCode = isoCountryCode
            }
            
            if let administrativeArea = placemarks?.first?.administrativeArea {
                LocationUtils.shared.provinceName = administrativeArea
            }
            
            if let postalCode = placemarks?.first?.postalCode {
                LocationUtils.shared.provinceCode = postalCode
            }
        }
    }
}

extension Location: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let isWhenInUseEnabled = status == .authorizedWhenInUse
        let isAlwaysEnabled = status == .authorizedAlways
        if !isWhenInUseEnabled && !isAlwaysEnabled {
            createSettingsAlert()
            authListener?(isWhenInUseEnabled || isAlwaysEnabled, settingsAlert)
            return
        }
        authListener?(isWhenInUseEnabled || isAlwaysEnabled, nil)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        lastKnownLocation = location
        succeedCoordinate = location.coordinate
        getLocationDetails(location: location)
    }

}
