//
//  Obfuscated.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public enum Obfuscated {
    public static let apiKey: [UInt8] = [27, 7, 21, 1, 56, 6, 24] // value is TestKey
}

public extension Sequence where Iterator.Element == UInt8 {
    
    // swiftlint:disable identifier_name
    var revealed: String {
        let cipher = Obfuscator().cipher
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in self.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }
    // swiftlint:enable identifier_name
    
}
