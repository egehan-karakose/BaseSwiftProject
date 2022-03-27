//
//  String+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public extension String {
    
    var localized: String {
        guard let bundle = String.localizedBundle else {
            fatalError("Bundle could not be found!")
        }
        return bundle.localizedString(forKey: self, value: nil, table: "Localization")
    }
    
    private static var localizedBundle: Bundle? {
        guard let commonBundle = Bundle.common,
            let locURL = commonBundle.url(forResource: "Localization", withExtension: "bundle"),
            let bundle = Bundle(url: locURL),
			let bundleUrl = bundle.url(forResource: Localization.currentLanguage.rawValue, withExtension: "lproj"),
            let bundleOfStrings = Bundle(url: bundleUrl) else { return nil }
        return bundleOfStrings
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: self.localized, arguments: args)
    }
}

public extension Double {
    
    /** Returns localized percentage string for given value */
    var localizedPercentage: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: Localization.currentLanguage.rawValue)
        return numberFormatter.string(from: NSNumber(value: self/100))
    }
}

public extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

public extension Int {
    var stringWithDecimalSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    func attributedCurrencyValue(currency: String) -> NSAttributedString? {
        var wholePartAttributes: [NSAttributedString.Key: Any] = [:]
        wholePartAttributes[.foregroundColor] = UIColor.appBlack1
        wholePartAttributes[.font] = UIFont.black(of: 14)
        
        var decimalPartAttributes: [NSAttributedString.Key: Any] = [:]
        decimalPartAttributes[.foregroundColor] = UIColor.appBlack1
        decimalPartAttributes[.font] = UIFont.black(of: 11)
        
        let wholePartFormatter = NumberFormatter()
        wholePartFormatter.usesGroupingSeparator = true
        wholePartFormatter.numberStyle = .decimal
        wholePartFormatter.roundingMode = .down
        wholePartFormatter.decimalSeparator = ","
        wholePartFormatter.groupingSeparator = "."
        wholePartFormatter.minimumFractionDigits = 0
        wholePartFormatter.maximumFractionDigits = 0
        
        let wholePartText = (wholePartFormatter.string(from: NSNumber(value: self)) ?? "") + " " + currency
        
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append( NSAttributedString(string: wholePartText, attributes: wholePartAttributes) )
        
        return attributedString
    }
    
}
