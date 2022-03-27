//
//  AttributedStringBuilder.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class AttributedStringBuilder {
    
    private(set) var font: UIFont?
    private(set) var foregroundColor: UIColor?
    private(set) var underlineStyle: NSUnderlineStyle?
    private(set) var paragraphStyle: NSMutableParagraphStyle?
    private(set) var textAlignment: NSTextAlignment?
    
    @discardableResult
    public func setFont(_ font: UIFont?) -> AttributedStringBuilder {
        self.font = font
        return self
    }
    
    @discardableResult
    public func setForegroundColor(_ foregroundColor: UIColor?) -> AttributedStringBuilder {
        self.foregroundColor = foregroundColor
        return self
    }
    
    @discardableResult
    public func setUnderlineStyle(_ underlineStyle: NSUnderlineStyle?) -> AttributedStringBuilder {
        self.underlineStyle = underlineStyle
        return self
    }
    
    @discardableResult
    public func setParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle?) -> AttributedStringBuilder {
        self.paragraphStyle = paragraphStyle
        return self
    }
    
    @discardableResult
    public func setLineSpacing(_ lineSpacing: CGFloat?) -> AttributedStringBuilder {
        guard let lineSpacing = lineSpacing else { return self }
        if self.paragraphStyle == nil {
            self.paragraphStyle = NSMutableParagraphStyle()
        }
        self.paragraphStyle?.lineSpacing = lineSpacing
        return self
    }
    
    @discardableResult
    public func setTextAlignment(_ textAlignment: NSTextAlignment?) -> AttributedStringBuilder {
        guard let textAlignment = textAlignment else { return self }
        if self.paragraphStyle == nil {
            self.paragraphStyle = NSMutableParagraphStyle()
        }
        self.paragraphStyle?.alignment = textAlignment
        return self
    }
    
    public func getAttributes() -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let foregroundColor = foregroundColor {
            attributes[.foregroundColor] = foregroundColor
        }
        if let underlineStyle = underlineStyle {
            attributes[.underlineStyle] = underlineStyle.rawValue
        }
        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
        }
        return attributes
    }
    
    public func build(with string: String?) -> NSAttributedString? {
        guard let string = string else { return nil }
        let attributes = getAttributes()
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    public init() { }
    
}
