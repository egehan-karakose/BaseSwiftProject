//
//  LocalizationConstants.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public enum Language: String {
    
    public static let defaultLanguage: Language = .tr
    
    // swiftlint:disable identifier_name
    case tr
    case en
//    case ar
    // swiftlint:enable identifier_name
    
    public var asParameter: String {
        switch self {
        case .en: return "en-US"
        case .tr: return "tr-TR"
        }
    }

	public var description: String {
		switch self {
		case .tr:
			return "TR"
		case .en:
			return "EN"
//		case .ar:
//			return "AR"
		}
	}
}
