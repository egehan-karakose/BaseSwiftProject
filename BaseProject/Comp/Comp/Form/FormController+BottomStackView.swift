//
//  FormController+BottomStackView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension FormController {
    
    @discardableResult
    @available(*, deprecated, message: "use bottomStackViewModel instead")
    public func addButton(with viewModel: FormButtonViewModel) -> FormButton {
        let button = FormButton()
        button.populate(with: viewModel)
        addViewToBottomStackView(button)
        return button
    }
    
    @available(*, deprecated, message: "use bottomStackViewModel instead")
    public func addButton(title: String = "DEVAM".localized, style: FormButtonStyle = .primary, action: VoidHandler?) {
        let viewModel = FormButtonViewModel(title: title, style: style)
        viewModel.handler = action
        let button = FormButton()
        button.populate(with: viewModel)
        addViewToBottomStackView(button)
    }
    
    public func addViewToBottomStackView(_ view: UIView?) {
        guard let view = view else { return }
        bottomStackView.addArrangedSubview(view)
    }
    
    public func setBottomStackViewInsets(insets: UIEdgeInsets?) {
        bottomStackView.isLayoutMarginsRelativeArrangement = true
        if #available(iOS 11.0, *) {
            bottomStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: insets?.top ?? 0,
                                                                               leading: insets?.left ?? 0,
                                                                               bottom: insets?.bottom ?? 0,
                                                                               trailing: insets?.right ?? 0)
        } else {
            bottomStackView.layoutMargins = UIEdgeInsets(top: insets?.top ?? 0,
                                                         left: insets?.left ?? 0,
                                                         bottom: insets?.bottom ?? 0,
                                                         right: insets?.right ?? 0)
        }
    }

    public func clearBottomStackView() {
        for view in bottomStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in bottomStackView.subviews {
            view.removeFromSuperview()
        }
    }
    
}

extension FormController {
    
    public class BottomStackViewModel {
        
        public static var defaultInsets = UIEdgeInsets(top: 10, left: 16, bottom: 24, right: 16)
        public static var zeroBottomInsets = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        
        public var insets: UIEdgeInsets?
        public var spacing: CGFloat?
        public var views: [UIView] = []
        public var backgroundColor: UIColor?
        
        public init() { }
        
    }
    
    func populateBottomStackView() {
        clearBottomStackView()
        guard let bottomStackViewModel = bottomStackViewModel else { return }
        for view in bottomStackViewModel.views {
            bottomStackView.addArrangedSubview(view)
        }
        
        setBottomStackViewInsets(insets: bottomStackViewModel.insets)
        if let backgroundColor = bottomStackViewModel.backgroundColor {
            bottomStackView.layer.backgroundColor = backgroundColor.cgColor
        }
        
        if let spacing = bottomStackViewModel.spacing {
            bottomStackView.spacing = spacing
        }
        
        bottomStackView.superview?.layoutIfNeeded()
    }

}
