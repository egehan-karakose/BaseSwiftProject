//
//  CustomableAlertDecoratorProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol CustomableAlertDecoratorProtocol: class {
    
    var mainView: UIView? { get set }
    
    var customView: UIView? { get set }
    
    var onClose: (() -> Void)? { get set }
    
    var canMove: Bool { get set }
    
    var closeTappedAround: Bool { get set }
    
    var animationTime: TimeInterval { get set }
    
    var closeableZoneRatio: CGFloat { get set }
    
    func setConstraints()
    
    func openingAnimate()
    
    func closingAnimate()
    
    func touchesBegan(touches: Set<UITouch>, event: UIEvent?)
    
    func touchesMoved(touches: Set<UITouch>, event: UIEvent?)
    
    func touchesEnd(touches: Set<UITouch>, event: UIEvent?)
    
}
