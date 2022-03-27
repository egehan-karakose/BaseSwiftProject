//
//  UIFont+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension UIFont {
    
    private enum VKFFont: String, CaseIterable {
        case black = "Roboto-Black"
        case blackItalic = "Roboto-BlackItalic"
        case bold = "Roboto-Bold"
        case boldItalic = "Roboto-BoldItalic"
        case italic = "Roboto-Italic"
        case light = "Roboto-Light"
        case lightItalic = "Roboto-LightItalic"
        case medium = "Roboto-Medium"
        case mediumItalic = "Roboto-MediumItalic"
        case regular = "Roboto-Regular"
        case thin = "Roboto-Thin"
        case thinItalic = "Roboto-ThinItalic"
    }
    
    // MARK: - Public font registration - programmatically
    
    public class func configure() {
        VKFFont.allCases.forEach({ register(with: $0.rawValue) })
        overrideInitialize()
        updateTabbarAppereance()
    }
    
    // MARK: - Private font registration
    
    private class func register(with name: String) {
        let fontPath = Bundle.common!.path(forResource: name, ofType: "ttf")
        let inData = NSData(contentsOfFile: fontPath!)
        var error: Unmanaged<CFError>?
        let provider = CGDataProvider(data: inData!)
        if let font = CGFont(provider!) {
            CTFontManagerRegisterGraphicsFont(font, &error)
            if error != nil { fatalError() }
        }
    }
    
    private class func updateTabbarAppereance() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(white: 0.57, alpha: 1.0),
            NSAttributedString.Key.font: UIFont.medium(of: 10)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attrs, for: .normal)
    }
 
    // MARK: - Public font helper
    
    public class func medium(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.medium.rawValue, size: size)!
    }
    
    public class func black(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.black.rawValue, size: size)!
    }
    
    public class func regular(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.regular.rawValue, size: size)!
    }
    
    public class func thin(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.thin.rawValue, size: size)!
    }
    
    public class func light(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.light.rawValue, size: size)!
    }
    
    public class func bold(of size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.bold.rawValue, size: size)!
    }
    
    // MARK: - Font overriding operations
    
    @objc private class func vkfFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.regular.rawValue, size: size)!
    }
    
    @objc private class func vkfBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.bold.rawValue, size: size)!
    }
    
    @objc private class func vkfItalicFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: VKFFont.italic.rawValue, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var font: VKFFont!
        switch fontAttribute {
        case "CTFontThinUsage", "CTFontUltraLightUsage":
            font = .thin
        case "CTFontLightUsage":
            font = .light
        case "CTFontRegularUsage":
            font = .regular
        case "CTFontDemiUsage", "CTFontMediumUsage" :
            font = .medium
        case "CTFontBoldUsage":
            font = .bold
        case "CTFontHeavyUsage", "CTFontBlackUsage":
            font = .black
        case "CTFontObliqueUsage":
            font = .italic
        default:
            font = .regular
        }
        self.init(name: font.rawValue, size: fontDescriptor.pointSize)!
    }
    
    private class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(vkfFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(vkfBoldFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(vkfItalicFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        // swiftlint:disable line_length
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
        // swiftlint:enable line_length
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}
