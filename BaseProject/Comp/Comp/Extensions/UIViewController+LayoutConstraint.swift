//
//  UIViewController+LayoutConstraint.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

// MARK: - Safe Area Related Constraints
extension UIViewController {
    
    public func embedToSafeArea(subview: UIView, constant: CGFloat = 0) {
        addTopSafeAreaConstraint(to: subview, constant: constant)
        addBottomSafeAreaConstraint(to: subview, constant: constant)
        addTrailingSafeAreaConstraint(to: subview, constant: constant)
        addLeadingSafeAreaConstraint(to: subview, constant: constant)
    }
    
    @discardableResult
    public func addTopSafeAreaConstraint(to subview: UIView,
                                         constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if #available(iOS 11, *) {
            let guideSafe = view.safeAreaLayoutGuide
            constraint = subview.topAnchor.constraint(equalTo: guideSafe.topAnchor,
                                                      constant: constant)
            
        } else {
            constraint =  subview.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor,
                                                       constant: constant)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func addBottomSafeAreaConstraint(to subview: UIView,
                                            constant: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        if #available(iOS 11, *) {
            let guideSafe = view.safeAreaLayoutGuide
            constraint = subview.bottomAnchor.constraint(equalTo: guideSafe.bottomAnchor,
                                                         constant: -constant)
        } else {
            constraint = subview.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor,
                                                         constant: -constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func addTrailingSafeAreaConstraint(to subview: UIView,
                                              constant: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        if #available(iOS 11, *) {
            let guideSafe = view.safeAreaLayoutGuide
            constraint = subview.trailingAnchor.constraint(equalTo: guideSafe.trailingAnchor,
                                                           constant: -constant)
        } else {
            let layoutGuide = view.layoutMarginsGuide
            constraint = subview.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor,
                                                           constant: -constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func addLeadingSafeAreaConstraint(to subview: UIView,
                                             constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if #available(iOS 11, *) {
            let guideSafe = view.safeAreaLayoutGuide
            constraint = subview.leadingAnchor.constraint(equalTo: guideSafe.leadingAnchor,
                                                          constant: constant)
        } else {
            let layoutGuide = view.layoutMarginsGuide
            constraint = subview.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,
                                                          constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
}
