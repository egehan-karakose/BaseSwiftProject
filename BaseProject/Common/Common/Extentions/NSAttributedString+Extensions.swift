//
//  NSAttributedString+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
import Foundation

public extension NSAttributedString {
    public func getAttributedKey(with string: String?) -> NSAttributedString? {
        let attributedKey = AttributedStringBuilder()
            .setForegroundColor(.appGray)
            .setFont(.regular(of: 14))
            .setTextAlignment(.left)
            .setLineSpacing(4)
            .build(with: string)
        return attributedKey
    }
    
    public func getAttributedValue(with string: String?) -> NSAttributedString? {
        let attributedValue = AttributedStringBuilder()
            .setForegroundColor(.appBlack1)
            .setFont(.regular(of: 14))
            .setTextAlignment(.right)
            .setLineSpacing(4)
            .build(with: string)
        return attributedValue
    }
    
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
