//
//  UITextField+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension UITextField: CustomDebugStringConvertible {
    
    open override var debugDescription: String {
        return super.debugDescription
            + "\n text color: \(textColor.debugDescription ?? "")"
    }
    
}

extension UILabel: CustomDebugStringConvertible {
    
    open override var debugDescription: String {
        return super.debugDescription
            + "\n text color: \(textColor.debugDescription ?? "")"
    }
    
}

extension UIColor: CustomDebugStringConvertible {
    
    open override var debugDescription: String {
        return "hex : \(toHexString())"
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        
        return String(format: "#%06x", rgb)
    }
}
