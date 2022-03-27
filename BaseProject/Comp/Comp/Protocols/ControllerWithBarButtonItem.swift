//
//  ControllerWithNewItemButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol ControllerWithNewItemButton {
    func addNewItemButton(completion:@escaping VoidHandler)
}

public extension ControllerWithNewItemButton where Self: UIViewController {
    func addNewItemButton(completion:@escaping VoidHandler) {
        let barButton = NewItemBarButton {
            completion()
        }
        navigationItem.rightBarButtonItem = barButton
    }
}
