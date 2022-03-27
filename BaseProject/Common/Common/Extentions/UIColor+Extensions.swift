//
//  UIColor+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

extension UIColor {
    
    // MARK: Primary
    public static let navigationTitle: UIColor = UIColor(rgb: 0x383838, alpha: 1)
    
    public static let appYellow: UIColor = UIColor(rgb: 0xFCB000, alpha: 1)
    public static let appDarkYellow: UIColor = UIColor(rgb: 0xF4A302, alpha: 1)
    public static let appOrange: UIColor = UIColor(rgb: 0xE68A06, alpha: 1)
    public static let appDarkOrange: UIColor = UIColor(rgb: 0xDE770B, alpha: 1)
    public static let appBlack1: UIColor = UIColor(rgb: 0x383838, alpha: 1)
    public static let appBlack2: UIColor = UIColor(rgb: 0x514F4F, alpha: 1)
    public static let appDisableGray: UIColor = UIColor(rgb: 0xD6D6D6, alpha: 1)
    
    // MARK: Secondary
    
    public static let appInvidualWebGray: UIColor = UIColor(rgb: 0xF2F2F2, alpha: 1)
    public static let appDarkGray: UIColor = UIColor(rgb: 0x737171, alpha: 1)
    public static let appGray: UIColor = UIColor(rgb: 0xA8A6A6, alpha: 1)
    public static let appLightGray: UIColor = UIColor(rgb: 0xDEDEDE, alpha: 1)
    public static let appGreen: UIColor = UIColor(rgb: 0x7ED321, alpha: 1)
    public static var appRed: UIColor = UIColor(rgb: 0xD0021B, alpha: 1)
    public static var appDarkRed: UIColor = UIColor(rgb: 0x942020, alpha: 1)
    
    // MARK: Background
    
    public static let appBackgroundDarkGray: UIColor = UIColor(rgb: 0xE5E5E5, alpha: 1)
    public static let appBackgroundGray: UIColor = UIColor(rgb: 0xF4F4F4, alpha: 1)
    public static let appBackgroundLightGray: UIColor = UIColor(rgb: 0x8E8E93, alpha: 0.12)
    
    // MARK: Others
    
    public static let cellDividerColor: UIColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    public static let backgroundWhite: UIColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    public static let defaultTextColor: UIColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
    public static let textColor: UIColor = #colorLiteral(red: 0.3176470588, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
    public static let descriptionTextColor = #colorLiteral(red: 0.4509803922, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
    public static let selectedTextColor: UIColor = #colorLiteral(red: 0.3176470588, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
    
    // MARK: SKY
    
    public static let skyDarkBlue: UIColor = UIColor(rgb: 0x242F3E, alpha: 1)
    public static let skyBlue: UIColor = UIColor(rgb: 0x242F3E, alpha: 1)
    
    // MARK: init
    
    public convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let redMasked = Int(color >> 16) & mask
        let greenMasked = Int(color >> 8) & mask
        let blueMasked = Int(color) & mask
        let red   = CGFloat(redMasked) / 255.0
        let green = CGFloat(greenMasked) / 255.0
        let blue  = CGFloat(blueMasked) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
