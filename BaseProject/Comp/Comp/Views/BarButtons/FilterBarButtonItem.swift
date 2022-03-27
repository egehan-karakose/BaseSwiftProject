//
//  FilterButtonItem.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

class FilterBarButtonItem: UIBarButtonItem {
    var callback: VoidHandler!
    
    init(with callback: @escaping VoidHandler) {
        super.init()
        self.callback = callback
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let image = UIImage(named: "filter", in: Bundle.uiComp, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didFilterBarButton), for: .touchUpInside)
        self.customView = button
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didFilterBarButton() {
        callback?()
    }
}
