//
//  Encryption.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import CommonCrypto
import Common

public final class AES256 {
    
    private static let keyData  = NetworkEnvironment.secretKey.revealed.data(using: .utf8)!
    private static let ivData = NetworkEnvironment.ivValue.revealed.data(using: .utf8)!

    // MARK: - Public Helpers
    
    public class var encrpytedKey: String {
        let date            = System.shared.appLaunchTimestamp
        let calculatedDate  = date * 17
        let value           = String(calculatedDate)
        
        let array: [String] = [NetworkEnvironment.identifier.revealed, value]

        if let data = try? JSONSerialization.data(withJSONObject: array, options: []) {
            let encryptedData = AES256.encrypt(data: data)
            return encryptedData.base64EncodedString()
        }
        // FIXME: add log here, this should not be happed
        return ""
    }
    
    // MARK: - Private Business Operation
    
    private class func encrypt(data: Data) -> Data {
        return crypt(data: data, operation: kCCEncrypt)
    }
    
    public class func decrypt(data: Data) -> Data {
        return crypt(data: data, operation: kCCDecrypt)
    }
    
    private class func crypt(data: Data, operation: Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        let keyLength             = size_t(kCCKeySizeAES256)
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        } else {
            // FIXME: put log here
            print("Error: \(cryptStatus)")
        }
        
        return cryptData
    }
    
}

