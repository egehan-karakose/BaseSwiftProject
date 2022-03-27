//
//  UIView+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit
import Common

public extension UIView {
    
    @discardableResult
    func fitInto(view: UIView, paddings: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        self.removeFromSuperview()
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let currentTopAnchor = self.topAnchor.constraint(equalTo: view.topAnchor, constant: paddings.top)
        currentTopAnchor.priority = UILayoutPriority(rawValue: 999)
        currentTopAnchor.isActive = true
        let currentBottomAnchor = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddings.bottom)
        currentBottomAnchor.priority = UILayoutPriority(rawValue: 999)
        currentBottomAnchor.isActive = true
        let currentLeadingAnchor = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddings.left)
        currentLeadingAnchor.priority = UILayoutPriority(rawValue: 999)
        currentLeadingAnchor.isActive = true
        let currentTrailingAnchor = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -paddings.right)
        currentTrailingAnchor.priority = UILayoutPriority(rawValue: 999)
        currentTrailingAnchor.isActive = true
        view.layoutIfNeeded()
        return [currentTopAnchor, currentLeadingAnchor, currentBottomAnchor, currentTrailingAnchor]
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat = 8) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
    }
    
    func scaleEffect() {
        UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    func rollbackScaleEffect() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func crossDisolve(_ handler: VoidHandler?) {
        UIView.transition(with: self,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: { handler?() },
                          completion: nil)
    }
    
    func findSuperview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview?.findSuperview(of: type)
    }
    
    func findSubview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.findSubview(of: type) }.first
    }
    
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subView in self.subviews {
            if let responder = subView.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = 1
        animation.values = [-10, 10, -10, 10, -5, 5, -2.5, 2.5, 0]
        self.layer.add(animation, forKey: "shake")
    }
    
    func endEditingOfFirstResponder() {
        guard let responder = self.findFirstResponder() else { return }
        guard let textField = responder as? UITextField else { return }
        textField.endEditing(true)
    }
    
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
    
}

extension UIView {
    
    public var isHiddenInStackView: Bool {
        get {
            return isHidden
        }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
    
}
