//
//  String+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension String {
    
    public var ibanMasked: String {
        let maskString = "TR## #### #### #### #### #### ##"
        let mask = JMStringMask(mask: maskString)
        let maskedText = mask.mask(string: self)
        return maskedText ?? self
    }
    
    public var creditCardMasked: String {
        let maskString = "#### #### #### ####"
        let mask = JMStringMask(mask: maskString)
        let maskedText = mask.mask(string: self.removingSpaces)
        return maskedText ?? self
    }
    
    public var firstLetterMask: String {
        guard !self.isEmpty else { return "" }
        return self.replaceCharAt(startIndex: 1, endIndex: self.count - 1, with: "*")
    }
    
    public func replaceCharAt(startIndex: Int, endIndex: Int, with: String.Element) -> String {
       return String(self.enumerated().map { index, char in
        return index >= startIndex && index <= endIndex ? with : char
       })
    }
    
    public func boldAttributed(fontSize: CGFloat = 14.0) -> NSAttributedString {
        let boldColorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBlack1]
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
                                 NSAttributedString.Key.foregroundColor: UIColor.appBlack1]
        let boldString = NSMutableAttributedString(string: self as String, attributes: boldColorAttribute)
        boldString.addAttributes(boldFontAttribute, range: NSRange(location: 0, length: self.count))
        return boldString
    }
}
