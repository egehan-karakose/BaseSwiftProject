//
//  Environment.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public enum NetworkEnvironment: String, CaseIterable {
    
    //swiftlint:disable line_length
    static let key: [UInt8] = [44, 37, 14, 3, 41, 52, 84, 4, 10, 55, 35, 50, 51, 69, 61, 16, 0, 35, 57, 7, 43, 33, 86, 2, 61, 9, 56, 14, 34, 53, 22, 24, 41, 38, 67, 81, 44, 51, 54, 11, 3, 54, 52, 30, 61, 39, 6, 0, 32, 37, 2, 80, 40, 28, 66, 8, 56, 30, 8, 8, 1, 38, 39, 15, 41, 36, 36, 13, 33, 8, 30, 95]
    static let identifier: [UInt8] = [44, 37, 14, 3, 41, 52, 84, 4, 10, 55, 35, 50, 51, 69, 61, 16, 0, 35, 57, 7, 43, 39, 10, 30, 41, 52, 84, 68, 14, 37, 21, 18, 60, 45, 58, 23, 59, 35, 37, 30, 1, 37, 51, 69, 62, 25, 48, 0, 33, 37, 2, 80, 40, 12, 67, 83, 56, 32, 8, 10, 3, 54, 10, 25, 61, 9, 32, 0, 53, 53, 21, 9, 43, 24, 42, 81, 47, 70, 38, 71, 2, 8, 35, 71]
    static let secretKey: [UInt8] = [31, 6, 53, 18, 37, 8, 56, 4, 92, 1, 121, 20, 95, 12, 87, 33, 71, 49, 71, 58, 100, 47, 4, 36, 22, 55, 9, 35, 2, 40, 62, 86]
    static let ivValue: [UInt8] = [39, 35, 82, 29, 63, 33, 32, 69, 3, 2, 32, 49, 52, 37, 22, 21]

    //swiftlint:enable line_length
    
    case test
    case linuxTest
    case preprod
    case production
    case load
    case pilot

    public var title: String {
        return rawValue.capitalizeFirst()
    }
    
    public var url: URL {
        var urlString = "https://swapi.dev/api/"
        switch self {
        case .production: urlString = ""
        case .preprod: urlString = ""
        case .test: urlString = "https://swapi.dev/api/"
        case .linuxTest: urlString = ""
        case .load: urlString = ""
        case .pilot: urlString = ""
        }
        return URL(string: urlString)!
    }
    
    public var msisdnUrl: URL {
        var urlString = "https://swapi.dev/api/"
        switch self {
        case .production: urlString = ""
        case .preprod: urlString = ""
        case .test: urlString = "https://swapi.dev/api/"
        case .linuxTest: urlString = "https://swapi.dev/api/"
        case .load: urlString = ""
        case .pilot: urlString = ""
        }
        return URL(string: urlString)!
    }
    
}

public final class Environment {
    
    public static let shared = Environment()
    
    public private(set) var current: NetworkEnvironment = .test {
        didSet {
            store()
        }
    }
    
    // MARK: - Private Initializing
    
    private init() {
        current = retrieve()
    }
    
    // MARK: - Public Helpers
    
    public func configure() {
        #if APPSTORE
            Environment.shared.change(with: .production)
        #elseif PROD || RELEASE
            Environment.shared.change(with: .production)
        #elseif PREPROD
            Environment.shared.change(with: .preprod)
        #elseif LOAD
            Environment.shared.change(with: .load)
        #elseif BETA
            Environment.shared.change(with: .test)
        #elseif LINUX
            Environment.shared.change(with: .linuxTest)
        #elseif DEBUG
            Environment.shared.change(with: .test)
        #elseif PILOT
            Environment.shared.change(with: .pilot)
        #endif
    }
    
    public func change(with new: NetworkEnvironment) {
        current = new
    }
    
    // MARK: - Private Helpers
    
    private func retrieve() -> NetworkEnvironment {
        let value: String? = BaseDefaults.shared.retrieve(with: .environment)
        if let valueWrapped = value,
            let env = NetworkEnvironment(rawValue: valueWrapped) {
            return env
        }
        return .test
    }
    
    private func store() {
        BaseDefaults.shared.store(with: .environment, value: current.rawValue)
    }
    
}

