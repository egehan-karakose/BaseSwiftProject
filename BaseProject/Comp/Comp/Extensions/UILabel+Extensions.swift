//
//  UILabel+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit

public extension UILabel {
    
    static let ibanMask = JMStringMask(mask: "__-- ---- ---- ---- ---- ---- --")
    static let cardMask = JMStringMask(mask: "---- ---- ---- ----")

    // swiftlint:disable line_length
    func setBoldRateValue(with value: String, boldSize: CGFloat = 20, regularSize: CGFloat = 16, colorize: Bool = false, divider: Character = ".", defaultColor: UIColor = .defaultTextColor, isFractionalBold: Bool = false) {
        let colorAttrs = defaultColor
        
        let normalAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: boldSize),
                           NSAttributedString.Key.foregroundColor: colorAttrs]
        let fractionalAttrs = [NSAttributedString.Key.font: isFractionalBold ?
            UIFont.boldSystemFont(ofSize: regularSize) : UIFont.systemFont(ofSize: regularSize),
                               NSAttributedString.Key.foregroundColor: colorAttrs]
        
       setRateValue(value: value, divider: divider, normalAttrs: normalAttrs, fractionalAttrs: fractionalAttrs)
    }
    
    func setBoldCurrencyValue(with value: Double, boldSize: CGFloat = 20, regularSize: CGFloat = 16, colorize: Bool = false, currency: String = "TL", defaultColor: UIColor = .defaultTextColor, isFractionalBold: Bool = false) {
        let colorAttrs = colorize ? value > 0 ? .appGreen :  defaultColor : defaultColor
        
        let normalAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: boldSize),
                           NSAttributedString.Key.foregroundColor: colorAttrs]
        let fractionalAttrs = [NSAttributedString.Key.font: isFractionalBold ?
            UIFont.boldSystemFont(ofSize: regularSize) : UIFont.systemFont(ofSize: regularSize),
                               NSAttributedString.Key.foregroundColor: colorAttrs]
        
       setCurrencyValue(value: value, currency: currency, normalAttrs: normalAttrs, fractionalAttrs: fractionalAttrs)
    }
    
    func setRegularCurrencyValue(with value: Double, regularSize: CGFloat = 20, lightSize: CGFloat = 16, colorize: Bool = false, currency: String = "TL", defaultColor: UIColor = .defaultTextColor) {
        let colorAttrs = colorize ? value > 0 ? .appGreen : defaultColor : defaultColor
        
        let normalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: regularSize),
                           NSAttributedString.Key.foregroundColor: colorAttrs]
        let fractionalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: lightSize, weight: .light),
                               NSAttributedString.Key.foregroundColor: colorAttrs]
        
        setCurrencyValue(value: value, currency: currency, normalAttrs: normalAttrs, fractionalAttrs: fractionalAttrs)
    }
    
    private func setRateValue(value: String, divider: Character, normalAttrs: [NSAttributedString.Key: NSObject], fractionalAttrs: [NSAttributedString.Key: NSObject]) {
        
        let normalSideString = NSMutableAttributedString(string: value, attributes: normalAttrs)
        if let dividerLocation = value.firstIndex(of: divider) {
            let index = value.distance(from: value.startIndex, to: dividerLocation)
            normalSideString.setAttributes(fractionalAttrs, range: NSRange(location: index + 1, length: value.count - (index + 1)))
            attributedText = normalSideString
        } else {
            text = value
        }
    }
    
    private func setCurrencyValue(value: Double, currency: String, normalAttrs: [NSAttributedString.Key: NSObject], fractionalAttrs: [NSAttributedString.Key: NSObject]) {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedValue = formatter.string(from: NSNumber(value: value)) {
            let normalSideString = NSMutableAttributedString(string: formattedValue, attributes: normalAttrs)
            normalSideString.setAttributes(fractionalAttrs, range: NSRange(location: normalSideString.length - 2, length: 2))
            
            normalSideString.append(NSAttributedString(string: " \(currency)", attributes: fractionalAttrs))
            
            attributedText = normalSideString
        } else {
            text = String(value)
        }
    }
    // swiftlint:enable line_length
    
    func setIban(with value: String?) {
        text = UILabel.ibanMask.mask(string: value)
    }
    
    func setCardNumber(with value: String?) {
        text = UILabel.cardMask.mask(string: value)
    }
    
    func fullfillWithDots(until size: CGFloat) {
        guard self.text != nil else { return }
        let accesLabelTitle = self.text
        while self.sizeThatFits(self.frame.size).width <= size {
            self.text = self.text! + "."
        }
        accessibilityLabel = accesLabelTitle
    }
    
    func setAmountAttributed(for amount: Double?, with currency: String) {
        guard let amount = amount?.formattedStringValue else {
            attributedText = nil
            return
        }
        
        let seperator: Character = amount.contains(",") ? "," : "."
        
        let group = amount.split(separator: seperator)
        let attributedString = NSMutableAttributedString()
        
        let group1Attributes = [NSAttributedString.Key.font: UIFont.regular(of: 23)]
        let group1AttributesString = NSAttributedString(string: String(group[0] + "\(seperator)"), attributes: group1Attributes)
        attributedString.append(group1AttributesString)
        
        let group2Attributes = [NSAttributedString.Key.font: UIFont.regular(of: 18)]
        let group2AttributesString = NSAttributedString(string: String(group[1]), attributes: group2Attributes)
        attributedString.append(group2AttributesString)
        
        let currencyAttributesString = NSAttributedString(string: String(" " + currency), attributes: group2Attributes)
        attributedString.append(currencyAttributesString)
        
        attributedText = attributedString
    }
}
