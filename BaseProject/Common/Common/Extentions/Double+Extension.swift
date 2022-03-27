//
//  Double+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import UIKit
// swiftlint:disable line_length
public extension Double {
    
    var moneyStringValue: String {
        return String(format: "%.2f", self)
    }

    var formattedStringValue: String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: self)
        if let formattedValue = formatter.string(from: number) {
            return formattedValue
        }
        return ""
    }
    
    func currencyValue(currency: String? = nil, hideDecimalSeperator: Bool = false, fractionOfDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.groupingSeparator = "."
        if !hideDecimalSeperator {
            formatter.decimalSeparator = ","
            formatter.minimumFractionDigits = fractionOfDigits
            formatter.maximumFractionDigits = fractionOfDigits
        }
        let number = NSNumber(value: self)
        if let formattedValue = formatter.string(from: number) {
            if let currency = currency,
                currency.isEmpty == false {
                return formattedValue + " " + currency
            } else {
                return formattedValue
            }
        }
        return ""
    }
    
    private func attributedCurrencyValue(currency: String,
                                         normalAttrs: [NSAttributedString.Key: NSObject],
                                         fractionalAttrs: [NSAttributedString.Key: NSObject], maximumFractionDigits: Int = 2) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.minimumFractionDigits = maximumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        let normalSideString = NSMutableAttributedString()
        if let formattedValue = formatter.string(from: NSNumber(value: self)) {
            normalSideString.append(NSMutableAttributedString(string: formattedValue, attributes: normalAttrs))
            normalSideString.setAttributes(fractionalAttrs, range: NSRange(location: normalSideString.length - maximumFractionDigits, length: maximumFractionDigits))
            normalSideString.append(NSAttributedString(string: " \(currency)", attributes: fractionalAttrs))
            return normalSideString
        }
        return normalSideString
    }
    
    /// Example output with headingTitle(optional) -> Maaş Ödemesi - 2.460,00 TL
    func amountFormatterWithHeadingTitleAndCurrency(headingTitle: String? = nil,
                                                    primaryFontSize: CGFloat = 20,
                                                    secondaryFontSize: CGFloat = 16,
                                                    useBoldFont: Bool = true,
                                                    currency: String = "TL",
                                                    defaultColor: UIColor = .black,
                                                    alignment: NSTextAlignment! = nil,
                                                    seperator: String = " - ",
                                                    maximumFractionDigits: Int = 2) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        if let receivedAlignment = alignment {
            paragraphStyle.alignment = receivedAlignment
        }
        var normalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: primaryFontSize),
                           NSAttributedString.Key.foregroundColor: defaultColor,
                           NSAttributedString.Key.paragraphStyle: paragraphStyle]
        var fractionalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: secondaryFontSize),
                               NSAttributedString.Key.foregroundColor: defaultColor,
                               NSAttributedString.Key.paragraphStyle: paragraphStyle]
        if useBoldFont {
            normalAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: primaryFontSize)
            fractionalAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: secondaryFontSize)
        }
        let mutableAttributedString = NSMutableAttributedString()
        if let receivedHeadingTitle = headingTitle {
            let trimmedReceivedHeadingTitle = receivedHeadingTitle.trimmingCharacters(in: .whitespacesAndNewlines) + seperator

            mutableAttributedString.append(NSMutableAttributedString(string: trimmedReceivedHeadingTitle, attributes: normalAttrs))
        }
        mutableAttributedString.append(self.attributedCurrencyValue(currency: currency, normalAttrs: normalAttrs, fractionalAttrs: fractionalAttrs, maximumFractionDigits: maximumFractionDigits))
        return mutableAttributedString
    }
    /// This extension returns as an integer attributed string if decimal places equals to zero.
    func amountIntegerLikeFormatter(primaryFontSize: CGFloat = 20,
                                    secondaryFontSize: CGFloat = 16,
                                    useBoldFont: Bool = true,
                                    currency: String = "",
                                    defaultColor: UIColor = .black,
                                    alignment: NSTextAlignment! = nil,
                                    maximumFractionDigits: Int = 2) -> NSAttributedString {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        
        if let amountInInt = self.intValue,
            Double(amountInInt) == self,
            let receivedAmountInString = formatter.string(from: NSNumber(value: self)) {

            let paragraphStyle = NSMutableParagraphStyle()
            if let receivedAlignment = alignment {
                paragraphStyle.alignment = receivedAlignment
            }
            var normalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: primaryFontSize),
                               NSAttributedString.Key.foregroundColor: defaultColor,
                               NSAttributedString.Key.paragraphStyle: paragraphStyle]
            var fractionalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: secondaryFontSize),
                                   NSAttributedString.Key.foregroundColor: defaultColor,
                                   NSAttributedString.Key.paragraphStyle: paragraphStyle]
            if useBoldFont {
                normalAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: primaryFontSize)
                fractionalAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: secondaryFontSize)
            }
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSMutableAttributedString(string: receivedAmountInString, attributes: normalAttrs))
            let trimmedCurrency = currency.trimWhitespaces
            if !trimmedCurrency.isEmpty {
                attributedString.append(NSAttributedString(string: " \(trimmedCurrency)", attributes: fractionalAttrs))
            }
            return attributedString
        } else {
            return self.amountFormatterWithHeadingTitleAndCurrency(primaryFontSize: primaryFontSize, secondaryFontSize: secondaryFontSize, useBoldFont: useBoldFont, currency: currency, defaultColor: defaultColor, alignment: alignment, seperator: "", maximumFractionDigits: maximumFractionDigits)
        }
    }
    
    /// This extension returns as an integer string if decimal places equals to zero.
    func amountIntegerLikeFormatterAsString() -> String {
        if let amountInInt = self.intValue,
            Double(amountInInt) == self {
            return "\(amountInInt)"
        } else {
            return "\(self)"
        }
    }

    var intValue: Int? {
        return self >= Double(Int.min) && self < Double(Int.max) ? Int(self): nil
    }
}
