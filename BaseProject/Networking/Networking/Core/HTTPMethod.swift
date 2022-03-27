//
//  HTTPMethod.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {

    case request
    case requestParameters(parameters: Parameters? = [:], encoding: ParameterEncoding)
    
}


public enum HTTPHeaders {
    
    case empty
    case systemJson
    case json
    case enteranceJson
    case securePayment

    var value: [String: String] {
        switch self {
        case .empty:
            return [:]
        case .json:
            return HeaderBuilder.build()
            
        case .enteranceJson:
            return HeaderBuilder.buildEnteranceExtras()
        case .systemJson:
            var header = HeaderBuilder.build()
            header["timestamp"] = String(System.shared.appLaunchTimestamp) // overriding timestamp
            return header
        case .securePayment:
            var header = HeaderBuilder.build()
            header["channel"] = "SecurePayment"
            return header
        }
    }
}

public class HeaderBuilder {
    
    struct Platform {
        
        static private let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }()
        
        static func isSimulatorText() -> String {
            return Platform.isSimulator ? "true" : "false"
        }
        
        // MARK: - Jailbroken checks
        
        static func isJailbroken() -> Bool {
            if !isSimulator {
                let directories = [
                    "/private/var/lib/cydia",
                    "/private/var/tmp/cydia.log",
                    "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                    "/usr/libexec/sftp-server",
                    "/usr/bin/sshd",
                    "/Applications/FakeCarrier.app",
                    "/Applications/SBSettings.app",
                    "/Applications/WinterBoard.app",
                    "/Applications/Cydia.app",
                    "/Library/MobileSubstrate/MobileSubstrate.dylib",
                    "/bin/bash",
                    "/usr/sbin/sshd",
                    "/etc/apt",
                    "/private/var/lib/apt/"
                ]
                
                for directory in directories {
                    if FileManager.default.fileExists(atPath: directory) {
                        return true
                    }
                }
                
                if let url = URL(string: "cydia://package/com.example.package"), UIApplication.shared.canOpenURL(url) {
                    return true
                }
                
                let stringToWrite = "Jailbreak Test"
                do {
                    try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: .utf8)
                    return true
                } catch {
                    return false
                }
            } else {
                return false
            }
        }
        
        static func isJailbrokenText() -> String {
            return Platform.isJailbroken() ? "true" : "false"
        }
    }
    
    // swiftlint:disable force_cast
    public class func build() -> [String: String] {
        var header = [String: String]()
        
//        header["Content-Type"] = "application/json;charset=uft-8"
//        header["Accept"] = "application/json"
//
//        header["client-key"] = NetworkEnvironment.key.revealed
//
//        header["app-build-number"] = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String)
//        header["build-serial"] = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String)
//        header["app-id"] = Bundle.main.bundleIdentifier
//
//        header["app-is-simulator"] = Platform.isSimulatorText()
//        header["is-rooted"] = Platform.isJailbrokenText()
//
//        header["culture"] = Localization.currentLanguage.asParameter
//
//        header["timestamp"] = String(Date().timeIntervalSince1970 * 1000)
//
//        header["channel"] = "Mobile"

        return header
    }
    
    class func buildEnteranceExtras() -> [String: String] {
        var header = build()
        header["latitude"] = LocationUtils.shared.getLatitude().getStringValue()
        header["longitude"] = LocationUtils.shared.getLongitude().getStringValue()
        header["country-code"] = LocationUtils.shared.getCountryCode().getStringValue()
        header["location-detail"] = LocationUtils.shared.getLocationDetails().getEncodedStringValue()
        header["country-name"] = LocationUtils.shared.getCountry().getEncodedStringValue()
        header["province-name"] = LocationUtils.shared.getProvinceName().getEncodedStringValue()
        header["province-code"] = LocationUtils.shared.getProvinceCode().getEncodedStringValue()
        
        return header
    }
    // swiftlint:enable force_cast
    
    public var launchedTimestampValue: Int = 0
}
