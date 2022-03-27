//
//  NSMutableAttributedString+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

public extension NSMutableAttributedString {
    func setFontFace(font: UIFont, color: UIColor? = nil) {
        beginEditing()
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, _) in
            if let fontValue = value as? UIFont,
                let newFontDescriptor = fontValue
                    .fontDescriptor.withFamily(font.familyName)
                    .withSymbolicTraits(fontValue.fontDescriptor.symbolicTraits) {
                let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
                removeAttribute(.font, range: range)
                addAttribute(.font, value: newFont, range: range)
                if let color = color {
                    removeAttribute(.foregroundColor, range: range)
                    addAttribute(.foregroundColor, value: color, range: range)
                }
            }
        }
        endEditing()
    }
    func getAttributedKeyValueSameLine(key: String?, value: String) -> NSMutableAttributedString? {
        let attributedString = NSAttributedString()
        guard let keyText = attributedString.getAttributedKey(with: String.init(format: "%@ ", key ?? "")) else { return nil}
        guard let valueText = attributedString.getAttributedValue(with: value) else { return nil}
        append(keyText)
        append(valueText)
        return self
    }
}
