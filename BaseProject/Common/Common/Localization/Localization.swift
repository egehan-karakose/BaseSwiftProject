//
//  Localization.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public final class Localization: NSObject {
    
	public static var currentLanguage: Language {
		get {
			let selected = NSLocale.preferredLanguages.first
			let value: String? = BaseDefaults.shared.retrieveString(with: .languageKey)
			if let languageValue = value {
				if let selectedLocale = selected?.prefix(2) {
					let locale = String(selectedLocale)
					if locale != languageValue {
						let language = Language(rawValue: locale) ?? Language.defaultLanguage
                        BaseDefaults.shared.storeString(with: .languageKey, value: language.rawValue)
						return language
					}
				}
				return Language(rawValue: languageValue) ?? Language.defaultLanguage
			} else {
                BaseDefaults.shared.storeString(with: .languageKey, value: Language.defaultLanguage.rawValue)
				UserDefaults.standard.set([Language.tr.rawValue], forKey: "AppleLanguages")
				UserDefaults.standard.synchronize()
				return Language.defaultLanguage
			}
		}
        set {
            BaseDefaults.shared.storeString(with: .languageKey, value: newValue.rawValue)
			UserDefaults.standard.set([newValue.rawValue], forKey: "AppleLanguages")
			UserDefaults.standard.synchronize()
//            if newValue == .ar {
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            } else if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            }
            // FIXME: there could be observable labels and more based on the needs.
            // or just updateding @ viewWillAppear will enough.
            // decisions should be made.
        }
    }
    
}
