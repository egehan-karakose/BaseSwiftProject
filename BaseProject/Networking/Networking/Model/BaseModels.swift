//
//  BaseModels.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

// FIXME: Take error codes into an array.
public struct ErrorPair: Codable {
    public let code: String?
    public let message: String?
    
    public init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
    
    public static func messaged(with message: String?) -> ErrorPair {
        return ErrorPair(code: "-1", message: message)
    }
    
}

public struct Status: Codable {
    public let errors: [ErrorPair]?
    public let hasError: Bool?
}

public struct KeyValuePair: Codable {
    public let key: String?
    public let value: String?
    public let isUpdateable: Bool?
    public let isInfoButtonActive: Bool?
    public let informationMessage: String?
}

public struct ResponseData<T: Codable>: Codable {
    public let status: Status?
    public let value: T?
}

