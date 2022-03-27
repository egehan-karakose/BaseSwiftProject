//
//  CustomableAlertViewProtocol.swift
//  UIComp
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol CustomableAlertViewProtocol where Self: UIView {
    
    var size: CGSize { get set }
    
    var onClose: (() -> Void)? { get set }
}
