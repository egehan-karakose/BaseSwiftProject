//
//  Encodable+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

public extension Encodable {
    
    var utf8String: String? {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(self) else { return nil }
        let text = String(data: data, encoding: .utf8)
        return text
    }
    
    func getParameters() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(AnyEncodable(self))
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Parameters
            if let jsonValue = json {
                return jsonValue
            }
        } catch { }
        
        return [String: Any]()
        
    }
    
}

extension Encodable {
    
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
    
}

struct AnyEncodable: Encodable {
    
    var value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
    
}
