//
//  LanguageBarButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public class LanguageBarButton: UIBarButtonItem {
	
    var callback: VoidHandler!
	var button: UIButton!
	
    public init(with callback: @escaping VoidHandler) {
        super.init()
        self.callback = callback
		button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
		button.setAttributedTitle(getAttributedTitle(), for: .normal)
        button.addTarget(self, action: #selector(didLanguageBarButton), for: .touchUpInside)
        self.customView = button
    }
    
	private func getTitle() -> String {
		var title = ""
		switch Localization.currentLanguage {
		case .tr:
			title = Language.en.description
		case .en:
			title = Language.tr.description
//		case .ar:
//			break
		}
		return title
	}
	
	private func getAttributedTitle() -> NSAttributedString? {
		let attributedText = AttributedStringBuilder()
					   .setFont(.boldSystemFont(ofSize: 14))
					   .setForegroundColor(.white)
					   .setTextAlignment(.center)
					   .build(with: getTitle())
		return attributedText
	}
	
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didLanguageBarButton() {
        callback?()
		button.setAttributedTitle(getAttributedTitle(), for: .normal)
    }
}
