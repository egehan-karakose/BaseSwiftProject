//
//  LocationUtils.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import CoreLocation

private var locationUtilsInstance: LocationUtils!

// MARK: - Use this Singleton in case of logging concerns
public class LocationUtils {
    
    // MARK: - Public Variables
    public var lastSucceedCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Module Private variables
    var country: String?
    var locationDetails: [AnyHashable: Any]?
    var countryCode: String?
    var provinceName: String?
    var provinceCode: String? {
        didSet {
            if let provinceCode = provinceCode, provinceCode.count >= 2 {
                cityCode = provinceCode.substring(fromIndex: 0, toIndex: 1)
            }
        }
    }
    var cityCode: String?
    
    // MARK: - Private Singleton Initializer
    private init() { }
    
    public func getLocationDetails() -> LocationRepresentation {
        guard let locationDetails = locationDetails else { return .nonAvailable }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: locationDetails, options: .init(rawValue:0))
            let jsonAsString: String = String.init(data: jsonData, encoding: String.Encoding.utf8)!
            return .locationDetails(details: jsonAsString)
        } catch {
            return .nonAvailable
        }
    }
    
    public func getLatitude() -> LocationRepresentation {
        guard let lastKnownCoordinate = lastSucceedCoordinate else { return .nonAvailable }
        return .latitude(lat: lastKnownCoordinate.latitude)
    }
    
    public func getLongitude() -> LocationRepresentation {
        guard let lastKnownCoordinate = lastSucceedCoordinate else { return .nonAvailable }
        return .longitude(lon: lastKnownCoordinate.longitude)
    }
    
    public func getCountry() -> LocationRepresentation {
        guard let country = country else { return .nonAvailable }
        return .locationDetails(details: country)
    }
    
    public func getCountryCode() -> LocationRepresentation {
        guard let countryCode = countryCode else { return .nonAvailable }
        return .locationDetails(details: countryCode)
    }
    
    public func getProvinceName() -> LocationRepresentation {
        guard let provinceName = provinceName else { return .nonAvailable }
        return .locationDetails(details: provinceName)
    }
    
    public func getProvinceCode() -> LocationRepresentation {
        guard let provinceCode = provinceCode else { return .nonAvailable }
        return .locationDetails(details: provinceCode)
    }
    
    public func getCityCode() -> LocationRepresentation {
        guard let cityCode = cityCode else { return .nonAvailable }
        return .locationDetails(details: cityCode)
    }
    
    public class var shared: LocationUtils {
        if locationUtilsInstance == nil {
            LocationUtils.setup()
        }
        return locationUtilsInstance
    }
    
    public class func setup() {
        locationUtilsInstance = LocationUtils()
    }
    
}

public enum LocationRepresentation {
    
    case nonAvailable
    case latitude(lat: Double)
    case longitude(lon: Double)
    case locationDetails(details: String)
    
    public func getStringValue() -> String {
        switch self {
        case .nonAvailable:
            return ""
        case .latitude(let lat):
            return lat.description
        case .longitude(let lon):
            return lon.description
        case .locationDetails(let details):
            return details
        }
    }
    
    public func getEncodedStringValue() -> String {
        switch self {
        case .nonAvailable:
            return ""
        case .latitude(let lat):
            return lat.description
        case .longitude(let lon):
            return lon.description
        case .locationDetails(let details):
            return details.lowercased().replacingOccurrences(of: "ı", with: "i")
                .folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
                .filter { $0.isASCII }
        }
    }
    
}
