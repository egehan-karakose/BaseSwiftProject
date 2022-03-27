//
//  UIView+LayoutConstraint.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public extension UIView {
    
    /// Embeds child view with given margin constant
    func embed(childView: UIView?, padding: CGFloat = 0) {
        guard let childView = childView else { return }
        embedVertically(childView: childView, padding: padding)
        embedHorizontally(childView: childView, padding: padding)
    }
    
    /// Adds vertical constraints to child view with given padding
    func embedVertically(childView: UIView?, padding: CGFloat = 0) {
        guard let childView = childView else { return }
        addBottomConstraint(to: childView, constant: padding)
        addTopConstraint(to: childView, constant: padding)
    }
    
    /// Adds horizontal constraints to child view with given padding
    func embedHorizontally(childView: UIView?, padding: CGFloat = 0) {
        guard let childView = childView else { return }
        addTrailingConstraint(to: childView, constant: padding)
        addLeadingConstraint(to: childView, constant: padding)
    }
    
    /// Adds views leading constraint to given view's leading anchor
    @discardableResult
    func addTrailingConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = trailingAnchor.constraint(equalTo: childView.trailingAnchor,
                                                   constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Adds views leading constraint to given view's leading anchor
    @discardableResult
    func addLeadingConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: childView.leadingAnchor,
                                                  constant: -constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Adds views top constraint to given view's top anchor
    @discardableResult
    func addTopConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: childView.topAnchor,
                                              constant: -constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Adds views bottom constraint to given anchor
    @discardableResult
    func addBottomConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: childView.bottomAnchor,
                                                 constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func addSafeAreaTopConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        
        var layoutAnchor = childView.topAnchor
        if #available(iOS 11.0, *) {
            layoutAnchor = childView.safeAreaLayoutGuide.topAnchor
        }
        
        let constraint = topAnchor.constraint(equalTo: layoutAnchor,
                                              constant: -constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func addSafeAreaBottomConstraint(to childView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        
        var layoutAnchor = childView.bottomAnchor
        if #available(iOS 11.0, *) {
            layoutAnchor = childView.safeAreaLayoutGuide.bottomAnchor
        }
        
        let constraint = bottomAnchor.constraint(equalTo: layoutAnchor,
                                                 constant: constant)
        constraint.isActive = true
        return constraint
    }
    
	func height(constant: CGFloat) {
	  setConstraint(value: constant, attribute: .height)
	}
	
	func width(constant: CGFloat) {
	  setConstraint(value: constant, attribute: .width)
	}
	
	private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
	  constraints.forEach {
		if $0.firstAttribute == attribute {
		  removeConstraint($0)
		}
	  }
	}
	
	private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
	  removeConstraint(attribute: attribute)
	  let constraint =
		NSLayoutConstraint(item: self,
						   attribute: attribute,
						   relatedBy: NSLayoutConstraint.Relation.equal,
						   toItem: nil,
						   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
						   multiplier: 1,
						   constant: value)
	  self.addConstraint(constraint)
	}
}
