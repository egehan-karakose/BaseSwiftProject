//
//  BarFilterButtonProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit
import Common

public protocol FilterBarButtonProtocol {
    func addFilterButton(completion:@escaping VoidHandler)
    func removeFilterButton()
}

public extension FilterBarButtonProtocol where Self: UIViewController {
    func addFilterButton(completion:@escaping VoidHandler) {
        let barButton = FilterBarButtonItem {
            completion()
        }
        navigationItem.rightBarButtonItem = barButton
    }
    func removeFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.title = ""
    }
}
