//
//  System.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import AdSupport

private var vkfSystemInfoInstance: System!

public class System {
    
    public private(set) var appLaunchTimestamp: Int64 = 0
    public private(set) var token: String? // This can be both client and authentication. Auth token overrides
    public private(set) var refreshToken: String?
    public private(set) var authTokenTickCount: TimeInterval = 0
    public private(set) var version: String!
    public private(set) var pushToken: String?
    public private(set) var forceIndividualUI: Bool?
    public private(set) var isEnLanguageSupported = false
    
    // MARK: - Public Helpers
    
    public var refreshTokenParameter: [String: String] {
        if let refreshToken = refreshToken, let token = token {
            return ["channel": "Mobile", "refreshToken": refreshToken, "token": token]
        }
        return ["channel": "Mobile"]
    }
    
    public class func setup() {
        vkfSystemInfoInstance = System()
    }
    
    public class var shared: System {
        if vkfSystemInfoInstance == nil {
            System.setup()
        }
        return vkfSystemInfoInstance
    }
    
    // MARK: - Initialization
    
    private init() {
        self.appLaunchTimestamp = Int64(Date().timeIntervalSince1970 * 1000.0)
        // swiftlint:disable force_cast
        self.version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        // swiftlint:enable force_cast
    }
    
    // MARK: - Public Helpers
    
    public func setClientTokenValue(_ value: String, tickCount: TimeInterval) {
        self.token = value
        self.authTokenTickCount = tickCount
    }
    
    public func setLanguageSupport(_ isEnLanguageSupported: Bool) {
        self.isEnLanguageSupported = isEnLanguageSupported
    }
    
    public func login(token: String, refreshToken: String) {
        // Auth token overrides client token value.
        self.token = token
        self.refreshToken = refreshToken
    }
    
    public func resetToken() {
        token = nil
    }
    
    public func setPushToken(_ value: String) {
        pushToken = value
    }
    
    public func setForceIndividualUI(forceIndividualUI: Bool?) {
        self.forceIndividualUI = forceIndividualUI
    }
    
    public func registerPushTokenToKobil(with registrationHandler: VoidHandler) {
        if pushToken != nil {
            registrationHandler()
        }
    }

    
    public func isTokenExist() -> Bool {
        return token != nil
    }
    
}

