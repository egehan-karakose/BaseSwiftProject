//
//  HomeBarButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit
import Common

public class HomeBarButton: UIBarButtonItem {
    
    var callback: VoidHandler!
    
    public init(with callback: @escaping VoidHandler) {
        super.init()
        self.callback = callback
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let image = UIImage(named: "homeButton", in: .uiComp, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapHomeBarButton), for: .touchUpInside)
        self.customView = button
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapHomeBarButton() {
        callback?()
    }
    
}
