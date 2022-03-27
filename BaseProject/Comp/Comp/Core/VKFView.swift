//
//  PLView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public class BaseView: UIView {
    
    override public func awakeAfter(using aDecoder: NSCoder) -> Any? {
        super.awakeAfter(using: aDecoder)
        
        if subviews.isEmpty {
            
            let view = type(of: self).loadFromNib()
            view.frame = frame
            view .autoresizingMask = autoresizingMask
            view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            
            for constraint in constraints {
                
                var firstItem = constraint.firstItem
                if let firstItemView = firstItem as? BaseView,
                    firstItemView == self {
                    firstItem = view
                }
                
                var secondItem = constraint.secondItem
                if let secondItemView = secondItem as? BaseView,
                    secondItemView == self {
                    secondItem = view
                }
                
                let constraint = NSLayoutConstraint(item: firstItem ?? BaseView(),
                                                    attribute: constraint.firstAttribute,
                                                    relatedBy: constraint.relation,
                                                    toItem: secondItem,
                                                    attribute: constraint.secondAttribute,
                                                    multiplier: constraint.multiplier,
                                                    constant: constraint.constant)
                view.addConstraint(constraint)
            }
            
            return view
        }
        
        return self
    }
}

extension BaseView: NibLoadable { }
